import https from "https";
import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";

const ssm = new SSMClient({});

function postToSlack(webhookUrl, payload) {
  return new Promise((resolve, reject) => {
    const url = new URL(webhookUrl);

    const req = https.request(
      {
        hostname: url.hostname,
        path: url.pathname + url.search,
        method: "POST",
        headers: { "Content-Type": "application/json" },
      },
      (res) => {
        res.on("data", () => {});
        res.on("end", () => resolve());
      }
    );

    req.on("error", reject);
    req.write(JSON.stringify(payload));
    req.end();
  });
}

function formatAlarmMessage(alarm) {
  const name = alarm.AlarmName ?? "Unknown";
  const state = alarm.NewStateValue ?? "UNKNOWN";
  const reason = alarm.NewStateReason ?? "";

  const emoji =
    state === "ALARM" ? "🚨" : state === "OK" ? "✅" : "⚠️";

  return {
    text: `${emoji} *CloudWatch Alarm*\n*Name:* ${name}\n*State:* ${state}\n*Reason:* ${reason}`,
  };
}

export const handler = async (event) => {
  const paramName = process.env.SLACK_WEBHOOK_SSM_PARAM;

  const paramResp = await ssm.send(
    new GetParameterCommand({ Name: paramName, WithDecryption: true })
  );

  const webhookUrl = paramResp?.Parameter?.Value;
  if (!webhookUrl || webhookUrl === "CHANGE_ME") {
    throw new Error(
      `Slack webhook is not set. Update SSM parameter ${paramName} with the real webhook URL.`
    );
  }

  // SNS -> Lambda event; could contain multiple records.
  for (const rec of event.Records ?? []) {
    const msg = rec?.Sns?.Message;
    let payload;

    // CloudWatch alarms publish JSON; if not JSON, send raw text.
    try {
      const alarm = JSON.parse(msg);
      payload = formatAlarmMessage(alarm);
    } catch {
      payload = { text: `⚠️ SNS Message\n\`\`\`\n${String(msg)}\n\`\`\`` };
    }

    await postToSlack(webhookUrl, payload);
  }

  return { ok: true };
};
