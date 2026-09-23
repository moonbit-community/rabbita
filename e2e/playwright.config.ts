import { defineConfig, devices } from '@playwright/test';

const isCI = Boolean(process.env.CI);
const mainApps = [
  { name: 'counter', port: 4300 },
  { name: 'state-and-messages', port: 4301 },
  { name: 'forms-and-events', port: 4302 },
  { name: 'collections-lifecycle', port: 4303 },
  { name: 'navigation-history', port: 4304 },
  { name: 'commands-and-async', port: 4305 },
  { name: 'http', port: 4306 },
  { name: 'subscriptions', port: 4307 },
  { name: 'dom-api', port: 4308 },
  { name: 'memo', port: 4310 },
] as const;
const ruiFixtures = [
  'calendar',
  'carousel',
  'command',
  'context-menu',
  'controls',
  'data-table',
  'dialogs',
  'disclosure',
  'drawer',
  'forms',
  'interaction-extended',
  'layout-extended',
  'menu',
  'message-scroller',
  'navigation-menu',
  'popover',
  'radio',
  'resizable',
  'routing',
  'select-combobox',
  'semantic-components',
  'sidebar',
  'slider',
  'toast',
  'tooltip',
] as const;
const apps = [
  {
    name: 'showcase',
    port: 4350,
    testMatch: '**/showcase*.spec.ts',
    command: 'warren -C ../website/homepage dev --browser-entry main --public-dir public --direct --port 4350',
  },
  ...mainApps.map(({ name, port }) => ({
    name,
    port,
    testMatch: [`**/${name}.spec.ts`, `**/${name}.*.spec.ts`],
    command: `warren -C ./apps/${name} dev --browser-entry . --direct --port ${port}`,
  })),
  ...ruiFixtures.map((fixture, index) => {
    const port = 4320 + index;
    return {
      name: `rui-${fixture}`,
      port,
      testMatch: `**/rui.${fixture}.spec.ts`,
      command: `warren -C ./apps/rui dev --browser-entry ./${fixture} --direct --port ${port}`,
    };
  }),
];
const appUrl = (port: number) => `http://127.0.0.1:${port}`;

export default defineConfig({
  testDir: './tests',
  outputDir: './test-results',
  fullyParallel: true,
  forbidOnly: isCI,
  retries: isCI ? 1 : 0,
  workers: isCI ? 1 : undefined,
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
  ],
  use: {
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',
  },
  projects: apps.map(({ name, port, testMatch }) => ({
    name: `${name}-chromium`,
    testMatch,
    use: {
      ...devices['Desktop Chrome'],
      baseURL: appUrl(port),
    },
  })),
  webServer: apps.map(({ command, port }) => ({
    command,
    url: appUrl(port),
    reuseExistingServer: !isCI,
    timeout: 120_000,
    stdout: 'pipe' as const,
  })),
});
