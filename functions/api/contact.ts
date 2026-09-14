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

function isFilled(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

function isWellFormed(body: Partial<ContactBody>): body is ContactBody {
  return (
    isFilled(body.name) &&
    isFilled(body.email) &&
    isFilled(body.brief) &&
    isFilled(body.scope) &&
    typeof body.company === "string"
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
 * Answers with a status and no body: the form only reads `response.status`, and an error string
 * would tell whoever is probing this endpoint more than they need. A tripped trap gets the same
 * `204` a real send does, so a bot cannot tell the difference.
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

  const sent = await fetch(RESEND_ENDPOINT, {
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
  });

  if (!sent.ok) {
    return new Response(null, { status: 502 });
  }

  return new Response(null, { status: 204 });
};
