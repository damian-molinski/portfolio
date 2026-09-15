/**
 * The secrets this function needs, all set on the Pages project rather than committed.
 *
 * `CONTACT_TO` is an environment variable rather than a literal so the destination address is not
 * in git history for a scraper to lift. `CONTACT_FROM` must be an address on a domain verified in
 * Resend — sending is refused outright otherwise.
 */
interface Env {
  RESEND_API_KEY: string;
  CONTACT_TO: string;
  CONTACT_FROM: string;
}

/**
 * The request body the form posts. `company` is the trap: no person ever fills it.
 */
interface ContactBody {
  name: string;
  email: string;
  brief: string;
  scope: string;
  company: string;
}

const RESEND_ENDPOINT = "https://api.resend.com/emails";

/**
 * Long enough for a slow upstream, short enough that the button does not sit on `Transmitting...`
 * until the platform kills the request. The form's own timeout is 20s, so it outlasts this and a
 * timeout here is always reported as this function's `502`, never as the form losing the server.
 */
const RESEND_TIMEOUT_MS = 10_000;

/**
 * The same pattern `ContactDraftBuilder` applies in the form, so a `400` means the same thing on
 * both sides of the wire. Deliberately loose — see the comment there.
 */
const EMAIL_PATTERN = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

function isFilled(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

function isWellFormed(body: Partial<ContactBody>): body is ContactBody {
  return (
    isFilled(body.name) &&
    isFilled(body.email) &&
    EMAIL_PATTERN.test(body.email.trim()) &&
    isFilled(body.brief) &&
    isFilled(body.scope) &&
    typeof body.company === "string"
  );
}

/**
 * The secrets that are missing, by name.
 *
 * A project deployed without them answers `503` rather than the `502` that means Resend looked at a
 * real enquiry and refused it — the two need different fixes, and they used to be indistinguishable.
 */
function missingSecrets(env: Env): string[] {
  return (["RESEND_API_KEY", "CONTACT_TO", "CONTACT_FROM"] as const).filter(
    (name) => !isFilled(env[name]),
  );
}

/**
 * Resend takes this as JSON, not as SMTP, so it does the header encoding. The newlines still go,
 * because a subject line spanning two lines is nobody's idea of a subject line.
 */
function subjectFor(body: ContactBody): string {
  const singleLine = body.name.replace(/[\r\n]+/g, " ").trim();

  return `Consultation enquiry — ${body.scope} — ${singleLine}`;
}

function bodyFor(body: ContactBody): string {
  return [
    `Name:  ${body.name}`,
    `Email: ${body.email}`,
    `Scope: ${body.scope}`,
    "",
    body.brief,
  ].join("\n");
}

/**
 * Relays a consultation enquiry to the site owner's inbox, and forgets it.
 *
 * Answers with a status and no body: the form maps the status to what it tells the visitor, and an
 * error string would tell whoever is probing this endpoint more than they need. A tripped trap gets
 * the same `204` a real send does, so a bot cannot tell the difference.
 *
 * Failures are logged instead, which is the only place the reason exists — read them with
 * `wrangler pages deployment tail`. **The enquiry itself is never logged**: the visitor's address
 * and their brief are the two things this function is trusted with, and Resend's own error text is
 * the whole diagnosis anyway.
 */
export const onRequestPost: PagesFunction<Env> = async (context) => {
  let body: Partial<ContactBody>;

  try {
    body = await context.request.json();
  } catch {
    return new Response(null, { status: 400 });
  }

  // Before validation: a bot that filled the trap gets no signal about what else was wrong.
  if (isFilled(body.company)) {
    return new Response(null, { status: 204 });
  }

  if (!isWellFormed(body)) {
    return new Response(null, { status: 400 });
  }

  const missing = missingSecrets(context.env);

  if (missing.length > 0) {
    console.error(`contact: not configured, missing ${missing.join(", ")}`);
    return new Response(null, { status: 503 });
  }

  let sent: Response;

  try {
    sent = await fetch(RESEND_ENDPOINT, {
      method: "POST",
      headers: {
        authorization: `Bearer ${context.env.RESEND_API_KEY}`,
        "content-type": "application/json",
      },
      body: JSON.stringify({
        from: context.env.CONTACT_FROM,
        to: context.env.CONTACT_TO,
        reply_to: body.email,
        subject: subjectFor(body),
        text: bodyFor(body),
      }),
      signal: AbortSignal.timeout(RESEND_TIMEOUT_MS),
    });
  } catch (error) {
    console.error(`contact: Resend unreachable after ${RESEND_TIMEOUT_MS}ms`, error);
    return new Response(null, { status: 502 });
  }

  if (!sent.ok) {
    // Resend's own message: an unverified domain, a rejected key, a `from` outside the domain.
    console.error(`contact: Resend refused with ${sent.status}`, await sent.text());
    return new Response(null, { status: sent.status === 429 ? 429 : 502 });
  }

  return new Response(null, { status: 204 });
};
