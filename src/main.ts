import { checkInhibitor, getInhibintors } from './utils.ts';
import { REGEX_INHIBITOR, REGEX_APP_ID } from './const.ts';

const exec = async (command: string) => {
  const td = new TextDecoder();
  const cmd = new Deno.Command('bash', { args: ['-c', command] });
  return td.decode((await cmd.output()).stdout);
};

const main = async () => {
  const cmdOut = await exec(getInhibintors());
  const inhibitors: string[] = [];

  for await (const match of cmdOut.matchAll(REGEX_INHIBITOR)) {
    const stdout = await exec(checkInhibitor(match[0]));
    const appId = stdout.match(REGEX_APP_ID)?.[0];

    if (!appId) {
      continue;
    }

    inhibitors.push(appId);
  }

  console.log(inhibitors);
};

main().catch((error) => {
  console.error(error);
  Deno.exit(1);
});
