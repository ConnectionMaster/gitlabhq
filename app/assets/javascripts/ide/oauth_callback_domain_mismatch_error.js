import Vue from 'vue';
import OAuthDomainMismatchError from './components/oauth_domain_mismatch_error.vue';
import { parseCallbackUrls, getOAuthCallbackUrl } from './lib/gitlab_web_ide/oauth_callback_urls';

export class OAuthCallbackDomainMismatchErrorApp {
  #el;
  #callbackUrls;
  #expectedCallbackUrl;

  constructor(el) {
    this.#el = el;
    this.#callbackUrls = parseCallbackUrls(el.dataset.callbackUrls);
    this.#expectedCallbackUrl = getOAuthCallbackUrl();
  }

  shouldRenderError() {
    if (!this.#callbackUrls.length) {
      return false;
    }

    return this.#callbackUrls.every(({ url }) => url !== this.#expectedCallbackUrl);
  }

  renderError() {
    const callbackUrls = this.#callbackUrls;
    const expectedCallbackUrl = this.#expectedCallbackUrl;
    const el = this.#el;

    if (!el) return null;

    return new Vue({
      el,
      render(createElement) {
        return createElement(OAuthDomainMismatchError, {
          props: {
            expectedCallbackUrl,
            callbackUrls,
          },
        });
      },
    });
  }
}
