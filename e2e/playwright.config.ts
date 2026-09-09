import { defineConfig, devices } from '@playwright/test';

const isCI = Boolean(process.env.CI);
const apps = [
  { name: 'counter', port: 4300 },
  { name: 'state-and-messages', port: 4301 },
  { name: 'forms-and-events', port: 4302 },
  { name: 'collections-lifecycle', port: 4303 },
  { name: 'navigation-history', port: 4304 },
  { name: 'commands-and-async', port: 4305 },
  { name: 'http', port: 4306 },
  { name: 'subscriptions', port: 4307 },
  { name: 'dom-api', port: 4308 },
  { name: 'rui', port: 4309 },
  { name: 'memo', port: 4310 },
] as const;
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
  projects: apps.map(({ name, port }) => ({
    name: `${name}-chromium`,
    testMatch: `**/${name}*.spec.ts`,
    use: {
      ...devices['Desktop Chrome'],
      baseURL: appUrl(port),
    },
  })),
  webServer: apps.map(({ name, port }) => ({
    command: `warren -C ./apps/${name} dev --browser-entry . --direct --port ${port}`,
    url: appUrl(port),
    reuseExistingServer: !isCI,
    timeout: 120_000,
    stdout: 'pipe' as const,
  })),
});
