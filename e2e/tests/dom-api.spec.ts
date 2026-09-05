import { expect, test } from '@playwright/test';

test('node, element, document, collection, HTML, image, and SVG APIs use real DOM objects', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Run node and element APIs' }).click();
  await expect(page.locator('#nodes-result')).toHaveText('passed');
});

test('canvas, paths, gradients, patterns, and image data use a real 2D context', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Run canvas APIs' }).click();
  await expect(page.locator('#canvas-result')).toHaveText('passed');
});

test('window, CSS, viewport, animation, scrolling, and performance APIs use browser state', async ({ page }) => {
  await page.goto('/');
  await page.locator('#event-target').evaluate((element) => {
    element.animate([{ opacity: 0.5 }, { opacity: 1 }], { duration: 10_000 });
  });

  await page.getByRole('button', { name: 'Run platform APIs' }).click();
  await expect(page.locator('#platform-result')).toHaveText('passed');
});

test('native dialogs, HTML dialog, and popover APIs preserve browser behavior', async ({ page }) => {
  await page.goto('/');
  const messages: string[] = [];
  page.on('dialog', async (dialog) => {
    messages.push(`${dialog.type()}:${dialog.message()}`);
    await dialog.accept();
  });

  await page.getByRole('button', { name: 'Run dialog APIs' }).click();
  await expect(page.locator('#dialogs-result')).toHaveText('passed');
  expect(messages).toEqual([
    'confirm:DOM confirm probe',
    'alert:DOM alert probe',
  ]);
});

test('resize, mutation, and intersection observers receive real browser records', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Run observer APIs' }).click();
  await expect(page.locator('#observers-result')).toHaveText('passed');
});

test('microtasks, timers, intervals, and animation frames run and cancel', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Run scheduling APIs' }).click();
  await expect(page.locator('#timers-result')).toHaveText('passed');
});

test('event targets and concrete browser event subtypes expose their native fields', async ({ page }) => {
  await page.goto('/');
  await page.evaluate(() => sessionStorage.removeItem('dom-api-beforeunload'));
  await page.getByRole('button', { name: 'Install event API probes' }).click();
  await expect(page.locator('#events-result')).toHaveText('ready');
  await expect(page.locator('#event-generic-result')).toHaveText('passed');

  const pointerTarget = page.locator('#event-target');
  await pointerTarget.click();
  await expect(page.locator('#event-pointer-result')).toHaveText('passed');

  await page.locator('#key-target').focus();
  await page.keyboard.press('Shift+K');
  await expect(page.locator('#event-keyboard-result')).toHaveText('passed');

  await page.evaluate(() => {
    const target = document.querySelector('#event-target')!;
    const input = document.querySelector('#input-target')!;
    target.dispatchEvent(new WheelEvent('wheel-probe', {
      deltaX: 1,
      deltaY: 2,
      deltaZ: 3,
      deltaMode: WheelEvent.DOM_DELTA_PIXEL,
    }));
    input.dispatchEvent(new InputEvent('input-probe', {
      data: 'x',
      inputType: 'insertText',
    }));
    target.dispatchEvent(new FocusEvent('focus-probe'));
    target.dispatchEvent(new CompositionEvent('composition-probe', { data: 'compose' }));
    target.dispatchEvent(new AnimationEvent('animation-probe', {
      animationName: 'fade',
      elapsedTime: 0.25,
      pseudoElement: '::before',
    }));
    target.dispatchEvent(new TransitionEvent('transition-probe', {
      propertyName: 'opacity',
      elapsedTime: 0.5,
      pseudoElement: '::after',
    }));
    target.dispatchEvent(new ToggleEvent('toggle-probe', {
      oldState: 'closed',
      newState: 'open',
    }));
    target.dispatchEvent(new CustomEvent('custom-probe', { detail: 'custom detail' }));
    target.dispatchEvent(new MessageEvent('message-probe', { data: 'message data' }));
    target.dispatchEvent(new BlobEvent('blob-probe', {
      data: new Blob(['blob']),
      timecode: 1.5,
    }));
    target.dispatchEvent(new DragEvent('drag-probe', { dataTransfer: new DataTransfer() }));
    target.dispatchEvent(new ClipboardEvent('clipboard-probe', { clipboardData: new DataTransfer() }));
  });

  await expect(page.locator('#event-wheel-result')).toHaveText('passed');
  await expect(page.locator('#event-subtypes-result')).toHaveText('passed');
  await page.reload();
  expect(await page.evaluate(() => sessionStorage.getItem('dom-api-beforeunload'))).toBe('passed');
});

test('pointer event casts accept iframe realm events and preserve fractional CSS pixels', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Install event API probes' }).click();

  await page.locator('#event-target').evaluate((target) => {
    const iframe = document.createElement('iframe');
    document.body.append(iframe);
    try {
      const iframeWindow = iframe.contentWindow as Window & typeof globalThis;
      target.dispatchEvent(new iframeWindow.PointerEvent('fractional-pointer-probe', {
        pointerId: 7,
        pointerType: 'mouse',
        isPrimary: true,
        clientX: 10.25,
        clientY: 20.75,
        screenX: 30.5,
        screenY: 40.125,
      }));
    } finally {
      iframe.remove();
    }
  });

  await expect(page.locator('#event-fractional-pointer-result')).toHaveText('passed');
});

test('blob, clipboard, promise, WebSocket, message, and close APIs cross the browser boundary', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write'], {
    origin: 'http://127.0.0.1:4308',
  });
  await page.routeWebSocket('ws://127.0.0.1:4308/dom-api-echo', (socket) => {
    socket.onMessage((message) => socket.send(`echo:${message}`));
  });
  await page.goto('/');

  await page.getByRole('button', { name: 'Run blob and clipboard APIs' }).click();
  await expect(page.locator('#async-result')).toHaveText('passed');
});

test('media element properties and browser-owned media collections are accessible', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Run media APIs' }).click();
  await expect(page.locator('#media-result')).toHaveText('passed');
});

test('history and location APIs perform real same-origin navigations', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Push URL' }).click();
  await expect(page).toHaveURL(/\/dom-api-pushed$/);
  await page.getByRole('button', { name: 'Replace URL' }).click();
  await expect(page).toHaveURL(/\/dom-api-replaced$/);
  await page.getByRole('button', { name: 'History back' }).click();
  await expect(page).toHaveURL(/\/$/);
  await page.getByRole('button', { name: 'History forward' }).click();
  await expect(page).toHaveURL(/\/dom-api-replaced$/);

  await Promise.all([
    page.waitForNavigation(),
    page.getByRole('button', { name: 'Reload URL' }).click(),
  ]);
  await page.getByRole('button', { name: 'Load URL', exact: true }).click();
  await expect(page).toHaveURL(/\/dom-api-loaded$/);
});
