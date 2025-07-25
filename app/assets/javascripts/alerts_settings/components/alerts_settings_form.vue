<script>
import {
  GlButton,
  GlForm,
  GlFormGroup,
  GlFormSelect,
  GlFormInput,
  GlFormInputGroup,
  GlFormTextarea,
  GlModal,
  GlModalDirective,
  GlSprintf,
  GlToggle,
  GlTabs,
  GlTab,
} from '@gitlab/ui';
import { isEqual, isEmpty, omit } from 'lodash';
import * as Sentry from '~/sentry/sentry_browser_wrapper';
import ClipboardButton from '~/vue_shared/components/clipboard_button.vue';
import { PROMO_URL, DOCS_URL_IN_EE_DIR } from '~/constants';
import {
  integrationTypes,
  integrationSteps,
  JSON_VALIDATE_DELAY,
  typeSet,
  i18n,
  tabIndices,
  testAlertModalId,
} from '../constants';
import getCurrentIntegrationQuery from '../graphql/queries/get_current_integration.query.graphql';
import parseSamplePayloadQuery from '../graphql/queries/parse_sample_payload.query.graphql';
import MappingBuilder from './alert_mapping_builder.vue';
import AlertSettingsFormHelpBlock from './alert_settings_form_help_block.vue';

export default {
  incidentManagementDocsLink: `${DOCS_URL_IN_EE_DIR}/operations/incident_management/integrations.html#configuration`,
  JSON_VALIDATE_DELAY,
  typeSet,
  integrationSteps,
  i18n,
  primaryProps: { text: i18n.integrationFormSteps.testPayload.savedAndTest },
  secondaryProps: { text: i18n.integrationFormSteps.testPayload.proceedWithoutSave },
  cancelProps: { text: i18n.integrationFormSteps.testPayload.cancel },
  testAlertModalId,
  components: {
    ClipboardButton,
    GlButton,
    GlForm,
    GlFormGroup,
    GlFormInput,
    GlFormInputGroup,
    GlFormTextarea,
    GlFormSelect,
    GlModal,
    GlSprintf,
    GlToggle,
    GlTabs,
    GlTab,
    AlertSettingsFormHelpBlock,
    MappingBuilder,
  },
  directives: {
    GlModal: GlModalDirective,
  },
  inject: {
    alertsUsageUrl: {
      default: '#',
    },
    multiIntegrations: {
      default: false,
    },
    projectPath: {
      default: '',
    },
  },
  props: {
    loading: {
      type: Boolean,
      required: true,
    },
    canAddIntegration: {
      type: Boolean,
      required: true,
    },
    alertFields: {
      type: Array,
      required: false,
      default: null,
    },
    tabIndex: {
      type: Number,
      required: false,
      default: tabIndices.configureDetails,
    },
  },
  apollo: {
    currentIntegration: {
      query: getCurrentIntegrationQuery,
    },
  },
  data() {
    return {
      integrationTypesOptions: Object.values(integrationTypes),
      samplePayload: {
        json: null,
        error: null,
        loading: false,
      },
      testPayload: {
        json: null,
        error: null,
      },
      resetPayloadAndMappingConfirmed: false,
      mapping: [],
      integrationForm: {
        active: false,
        type: integrationTypes.none.value,
        name: '',
        token: '',
        url: '',
      },
      activeTabIndex: this.tabIndex,
      currentIntegration: null,
      parsedPayload: [],
      validationState: {
        name: true,
      },
      pricingLink: `${PROMO_URL}/pricing`,
    };
  },
  computed: {
    isPrometheus() {
      return this.integrationForm.type === typeSet.prometheus;
    },
    isHttp() {
      return this.integrationForm.type === typeSet.http;
    },
    isNone() {
      return !this.isHttp && !this.isPrometheus;
    },
    isCreating() {
      return !this.currentIntegration;
    },
    isSampePayloadValid() {
      return this.samplePayload.error === null;
    },
    isTestPayloadValid() {
      return this.testPayload.error === null;
    },
    testAlertPayload() {
      return {
        data: this.testPayload.json,
        endpoint: this.integrationForm.url,
        token: this.integrationForm.token,
      };
    },
    showMappingBuilder() {
      return this.multiIntegrations && this.integrationForm.type && this.alertFields?.length;
    },
    hasSamplePayload() {
      return this.isValidNonEmptyJSON(this.currentIntegration?.payloadExample);
    },
    canEditPayload() {
      return this.hasSamplePayload && !this.resetPayloadAndMappingConfirmed;
    },
    canParseSamplePayload() {
      return this.isSampePayloadValid && this.samplePayload.json;
    },
    isSelectDisabled() {
      return this.currentIntegration !== null || !this.canAddIntegration;
    },
    viewCredentialsHelpMsg() {
      return this.isPrometheus
        ? i18n.integrationFormSteps.setupCredentials.prometheusHelp
        : i18n.integrationFormSteps.setupCredentials.help;
    },
    customMappingHelpMsg() {
      return this.isPrometheus
        ? i18n.integrationFormSteps.mapFields.prometheusHelp
        : i18n.integrationFormSteps.mapFields.help;
    },
    isFormValid() {
      return (
        Object.values(this.validationState).every(Boolean) &&
        !this.isNone &&
        this.isSampePayloadValid
      );
    },
    isFormDirty() {
      const {
        type,
        active,
        name,
        payloadAlertFields = [],
        payloadAttributeMappings = [],
      } = this.currentIntegration || {};
      const { name: formName, active: formActive, type: formType } = this.integrationForm;

      const isDirty =
        type !== formType ||
        active !== formActive ||
        name !== formName ||
        !isEqual(this.parsedPayload, payloadAlertFields) ||
        !isEqual(this.mapping, this.getCleanMapping(payloadAttributeMappings));

      return isDirty;
    },
    canSubmitForm() {
      return this.isFormValid && this.isFormDirty;
    },
    dataForSave() {
      const { name, active, type } = this.integrationForm;
      const customMappingVariables = {
        payloadAttributeMappings: this.mapping,
        payloadExample: this.samplePayload.json || '{}',
      };

      const variables = { name, active, type, ...customMappingVariables };

      return { variables };
    },
    testAlertModal() {
      return this.isFormDirty ? testAlertModalId : null;
    },
  },
  watch: {
    tabIndex(val) {
      // some interactions change activeTabIndex but not tabIndex, so reset first
      this.activeTabIndex = tabIndices.configureDetails;
      this.activeTabIndex = val;
    },
    currentIntegration(val) {
      if (val === null) {
        this.reset();
        return;
      }

      this.resetPayloadAndMapping();
      const {
        name,
        type,
        active,
        url,
        token,
        payloadExample,
        payloadAlertFields,
        payloadAttributeMappings,
      } = val;
      this.integrationForm = { type, name, active, url, token };

      if (this.showMappingBuilder) {
        this.resetPayloadAndMappingConfirmed = false;
        this.parsedPayload = payloadAlertFields;
        this.samplePayload.json = this.getPrettifiedPayload(payloadExample);
        this.updateMapping(this.getCleanMapping(payloadAttributeMappings));
      }
      this.$el.scrollIntoView({ block: 'center' });
    },
  },
  methods: {
    getCleanMapping(mapping) {
      return mapping.map((mappingItem) => omit(mappingItem, '__typename'));
    },
    setIntegrationName(value) {
      this.integrationForm.name = value;
      this.validateName();
    },
    setJSONPayload(value) {
      this.testPayload.json = value;
      this.validateJson(false);
    },
    validateName() {
      this.validationState.name = Boolean(this.integrationForm.name?.length);
    },
    isValidNonEmptyJSON(JSONString) {
      if (JSONString) {
        let parsed;
        try {
          parsed = JSON.parse(JSONString);
        } catch (error) {
          Sentry.captureException(error);
        }
        if (parsed) return !isEmpty(parsed);
      }
      return false;
    },
    getPrettifiedPayload(payload) {
      return this.isValidNonEmptyJSON(payload)
        ? JSON.stringify(JSON.parse(payload), null, '\t')
        : null;
    },
    triggerValidation() {
      this.validateName();
      if (!this.validationState.name) {
        this.$refs.integrationName.$el.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    },
    sendTestAlert() {
      this.$emit('test-alert-payload', this.testAlertPayload);
    },
    saveAndSendTestAlert() {
      this.$emit('save-and-test-alert-payload', this.dataForSave, this.testAlertPayload);
    },
    submit(testAfterSubmit = false) {
      this.triggerValidation();

      if (!this.isFormValid) {
        return;
      }
      const event = this.currentIntegration ? 'update-integration' : 'create-new-integration';
      this.$emit(event, this.dataForSave, testAfterSubmit);
    },
    reset() {
      this.resetFormValues();
      this.resetPayloadAndMapping();
      this.$emit('clear-current-integration');
    },
    resetFormValues() {
      this.integrationForm.type = integrationTypes.none.value;
      this.integrationForm.name = '';
      this.integrationForm.active = false;
      this.samplePayload = {
        json: null,
        error: null,
      };
    },
    resetAuthKey() {
      if (!this.currentIntegration) {
        return;
      }

      this.$emit('reset-token', {
        variables: { id: this.currentIntegration.id },
      });
    },
    validateJson(isSamplePayload = true) {
      const payload = isSamplePayload ? this.samplePayload : this.testPayload;

      payload.error = null;
      if (payload.json === '') {
        return;
      }

      try {
        JSON.parse(payload.json);
      } catch (e) {
        payload.error = JSON.stringify(e.message);
      }
    },
    parseSamplePayload() {
      this.samplePayload.loading = true;

      return this.$apollo
        .query({
          query: parseSamplePayloadQuery,
          variables: { projectPath: this.projectPath, payload: this.samplePayload.json },
        })
        .then(
          ({
            data: {
              project: { alertManagementPayloadFields },
            },
          }) => {
            this.parsedPayload = alertManagementPayloadFields;
            this.resetPayloadAndMappingConfirmed = false;

            this.$toast.show(
              this.$options.i18n.integrationFormSteps.mapFields.payloadParsedSuccessMsg,
            );
          },
        )
        .catch(({ message }) => {
          this.samplePayload.error = message;
        })
        .finally(() => {
          this.samplePayload.loading = false;
        });
    },
    updateMapping(mapping) {
      this.mapping = mapping;
    },
    resetPayloadAndMapping() {
      this.resetPayloadAndMappingConfirmed = true;
      this.parsedPayload = [];
      this.updateMapping([]);
    },
  },
};
</script>

<template>
  <gl-form @submit.prevent="submit" @reset.prevent="reset">
    <gl-tabs v-model="activeTabIndex">
      <gl-tab :title="$options.i18n.integrationTabs.configureDetails" class="gl-mt-3">
        <gl-form-group
          v-if="isCreating"
          id="integration-type"
          :label="$options.i18n.integrationFormSteps.selectType.label"
          label-for="integration-type"
        >
          <gl-form-select
            id="integration-type"
            v-model="integrationForm.type"
            :disabled="isSelectDisabled"
            class="gl-max-w-full"
            data-testid="integration-type-dropdown"
            :options="integrationTypesOptions"
            autofocus
          />

          <alert-settings-form-help-block
            v-if="!canAddIntegration"
            disabled="true"
            class="gl-my-4 gl-inline-block"
            :message="$options.i18n.integrationFormSteps.selectType.enterprise"
            :link="pricingLink"
            data-testid="multi-integrations-not-supported"
          />
        </gl-form-group>
        <div class="gl-mt-3">
          <gl-form-group
            v-if="integrationForm.type"
            :label="$options.i18n.integrationFormSteps.nameIntegration.label"
            label-for="name-integration"
            :invalid-feedback="$options.i18n.integrationFormSteps.nameIntegration.error"
            :state="validationState.name"
          >
            <gl-form-input
              id="name-integration"
              ref="integrationName"
              :value="integrationForm.name"
              type="text"
              :placeholder="$options.i18n.integrationFormSteps.nameIntegration.placeholder"
              data-testid="integration-name-field"
              @input="setIntegrationName"
            />
          </gl-form-group>

          <gl-form-group
            v-if="!isNone"
            :label="$options.i18n.integrationFormSteps.enableIntegration.label"
          >
            <span>{{ $options.i18n.integrationFormSteps.enableIntegration.help }}</span>

            <gl-toggle
              id="enable-integration"
              v-model="integrationForm.active"
              :is-loading="loading"
              :label="$options.i18n.integrationFormSteps.nameIntegration.activeToggle"
              data-testid="active-toggle-container"
              class="gl-mt-4 gl-font-normal"
            />
          </gl-form-group>
          <template v-if="showMappingBuilder">
            <gl-form-group
              data-testid="sample-payload-section"
              :label="$options.i18n.integrationFormSteps.mapFields.label"
              label-for="sample-payload"
              class="!gl-mb-0"
              :invalid-feedback="samplePayload.error"
            >
              <gl-sprintf :message="customMappingHelpMsg">
                <template #code="{ content }">
                  <code>{{ content }}</code>
                </template>
              </gl-sprintf>

              <gl-form-textarea
                id="sample-payload"
                v-model="samplePayload.json"
                :disabled="canEditPayload"
                :state="isSampePayloadValid"
                :placeholder="$options.i18n.integrationFormSteps.mapFields.placeholder"
                class="gl-my-3"
                :debounce="$options.JSON_VALIDATE_DELAY"
                rows="6"
                max-rows="10"
                no-resize
                @input="validateJson"
              />
            </gl-form-group>

            <gl-button
              v-if="canEditPayload"
              v-gl-modal.resetPayloadModal
              data-testid="payload-action-btn"
              :disabled="!integrationForm.active"
              class="gl-mt-3"
            >
              {{ $options.i18n.integrationFormSteps.mapFields.editPayload }}
            </gl-button>

            <gl-button
              v-else
              data-testid="payload-action-btn"
              :class="{ 'gl-mt-3': samplePayload.error }"
              :disabled="!canParseSamplePayload"
              :loading="samplePayload.loading"
              @click="parseSamplePayload"
            >
              {{ $options.i18n.integrationFormSteps.mapFields.parsePayload }}
            </gl-button>
            <gl-modal
              modal-id="resetPayloadModal"
              :title="$options.i18n.integrationFormSteps.mapFields.resetHeader"
              :ok-title="$options.i18n.integrationFormSteps.mapFields.resetOk"
              ok-variant="danger"
              @ok="resetPayloadAndMappingConfirmed = true"
            >
              {{ $options.i18n.integrationFormSteps.mapFields.resetBody }}
            </gl-modal>

            <div class="gl-mt-5">
              <span>{{ $options.i18n.integrationFormSteps.mapFields.mapIntro }}</span>
              <mapping-builder
                :parsed-payload="parsedPayload"
                :saved-mapping="mapping"
                :alert-fields="alertFields"
                @onMappingUpdate="updateMapping"
              />
            </div>
          </template>
        </div>
        <div class="gl-flex gl-flex-col gl-justify-start gl-gap-3 md:gl-flex-row">
          <gl-button
            :disabled="!canSubmitForm"
            variant="confirm"
            class="js-no-auto-disable"
            data-testid="integration-form-submit"
            @click="submit(false)"
          >
            {{ $options.i18n.saveIntegration }}
          </gl-button>

          <gl-button
            :disabled="!canSubmitForm"
            variant="confirm"
            category="secondary"
            class="js-no-auto-disable"
            data-testid="save-and-create-alert-button"
            @click="submit(true)"
          >
            {{ $options.i18n.saveAndTestIntegration }}
          </gl-button>

          <gl-button type="reset" class="js-no-auto-disable">{{
            $options.i18n.cancelAndClose
          }}</gl-button>
        </div>
      </gl-tab>

      <gl-tab
        :title="$options.i18n.integrationTabs.viewCredentials"
        :disabled="isCreating"
        class="gl-mt-3"
      >
        <alert-settings-form-help-block
          :message="viewCredentialsHelpMsg"
          :link="$options.incidentManagementDocsLink"
        />

        <gl-form-group id="integration-webhook">
          <div class="gl-my-4">
            <span class="gl-font-bold">
              {{ $options.i18n.integrationFormSteps.setupCredentials.webhookUrl }}
            </span>

            <gl-form-input-group id="url" readonly :value="integrationForm.url">
              <template #append>
                <clipboard-button
                  :text="integrationForm.url || ''"
                  :title="$options.i18n.copy"
                  class="!gl-m-0"
                />
              </template>
            </gl-form-input-group>
          </div>

          <div class="gl-my-4">
            <span class="gl-font-bold">
              {{ $options.i18n.integrationFormSteps.setupCredentials.authorizationKey }}
            </span>

            <gl-form-input-group
              id="authorization-key"
              class="gl-mb-3"
              readonly
              :value="integrationForm.token"
            >
              <template #append>
                <clipboard-button
                  :text="integrationForm.token || ''"
                  :title="$options.i18n.copy"
                  class="!gl-m-0"
                />
              </template>
            </gl-form-input-group>
          </div>
        </gl-form-group>

        <div class="gl-flex gl-justify-start gl-py-3">
          <gl-button v-gl-modal.authKeyModal variant="danger">
            {{ $options.i18n.integrationFormSteps.setupCredentials.reset }}
          </gl-button>

          <gl-button type="reset" class="js-no-auto-disable gl-ml-3">
            {{ $options.i18n.cancelAndClose }}
          </gl-button>
        </div>

        <gl-modal
          modal-id="authKeyModal"
          :title="$options.i18n.integrationFormSteps.setupCredentials.reset"
          :ok-title="$options.i18n.integrationFormSteps.setupCredentials.reset"
          ok-variant="danger"
          @ok="resetAuthKey"
        >
          {{ $options.i18n.integrationFormSteps.restKeyInfo.label }}
        </gl-modal>
      </gl-tab>

      <gl-tab
        :title="$options.i18n.integrationTabs.sendTestAlert"
        :disabled="isCreating"
        class="gl-mt-3"
      >
        <gl-form-group id="test-integration" :invalid-feedback="testPayload.error">
          <alert-settings-form-help-block
            :message="$options.i18n.integrationFormSteps.testPayload.help"
            :link="alertsUsageUrl"
          />

          <gl-form-textarea
            id="test-payload"
            :value="testPayload.json"
            :state="isTestPayloadValid"
            :placeholder="$options.i18n.integrationFormSteps.testPayload.placeholder"
            class="gl-my-3"
            :debounce="$options.JSON_VALIDATE_DELAY"
            rows="6"
            max-rows="10"
            no-resize
            data-testid="test-payload-field"
            @input="setJSONPayload"
          />
        </gl-form-group>
        <div class="gl-flex gl-justify-start gl-py-3">
          <gl-button
            v-gl-modal="testAlertModal"
            :disabled="!isTestPayloadValid"
            :loading="loading"
            data-testid="send-test-alert"
            variant="confirm"
            class="js-no-auto-disable"
            @click="isFormDirty ? null : sendTestAlert()"
          >
            {{ $options.i18n.send }}
          </gl-button>

          <gl-button type="reset" class="js-no-auto-disable gl-ml-3">
            {{ $options.i18n.cancelAndClose }}
          </gl-button>
        </div>

        <gl-modal
          :modal-id="$options.testAlertModalId"
          :title="$options.i18n.integrationFormSteps.testPayload.modalTitle"
          :action-primary="$options.primaryProps"
          :action-secondary="$options.secondaryProps"
          :action-cancel="$options.cancelProps"
          @primary="saveAndSendTestAlert"
          @secondary="sendTestAlert"
        >
          {{ $options.i18n.integrationFormSteps.testPayload.modalBody }}
        </gl-modal>
      </gl-tab>
    </gl-tabs>
  </gl-form>
</template>
