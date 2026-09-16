interface Env {
  RESEND_API_KEY: string;
  CONTACT_TO: string;
  CONTACT_FROM: string;
}

interface ContactBody {
  name: string;
  email: string;
  brief: string;
  scope: string;
  company: string;
}

const RESEND_ENDPOINT = "https://api.resend.com/emails";

// Under the form's own 20s, so a timeout here is always reported as this function's 502.
const RESEND_TIMEOUT_MS = 10_000;

// The same pattern `ContactDraftBuilder` applies, so a 400 means the same thing on both sides.
const EMAIL_PATTERN = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

function isFilled(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

// `Request.json<T>()` asserts rather than checks, and `JSON.parse("null")` succeeds — without this
// the first property read throws, and a 500 reads to the visitor as "mail delivery is down".
function isRecord(body: unknown): body is Partial<ContactBody> {
  return typeof body === "object" && body !== null && !Array.isArray(body);
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

function missingSecrets(env: Env): string[] {
  return (["RESEND_API_KEY", "CONTACT_TO", "CONTACT_FROM"] as const).filter(
    (name) => !isFilled(env[name]),
  );
}

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

export const onRequestPost: PagesFunction<Env> = async (context) => {
  let parsed: unknown;

  try {
    parsed = await context.request.json<unknown>();
  } catch {
    return new Response(null, { status: 400 });
  }

  if (!isRecord(parsed)) {
    return new Response(null, { status: 400 });
  }

  const body = parsed;

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

  // Only the reason, never the enquiry: the visitor's address and their brief stay out of the logs.
  if (!sent.ok) {
    console.error(`contact: Resend refused with ${sent.status}`, await sent.text());
    return new Response(null, { status: sent.status === 429 ? 429 : 502 });
  }

  return new Response(null, { status: 204 });
};
