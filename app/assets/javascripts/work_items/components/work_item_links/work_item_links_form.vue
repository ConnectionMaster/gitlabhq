<script>
import { GlFormGroup, GlForm, GlButton, GlFormInput, GlFormCheckbox, GlTooltip } from '@gitlab/ui';
import { __, s__, sprintf } from '~/locale';
import glFeatureFlagsMixin from '~/vue_shared/mixins/gl_feature_flags_mixin';
import { fetchPolicies } from '~/lib/graphql';
import WorkItemTokenInput from '../shared/work_item_token_input.vue';
import { addHierarchyChild, addHierarchyChildren } from '../../graphql/cache_utils';
import namespaceWorkItemTypesQuery from '../../graphql/namespace_work_item_types.query.graphql';
import updateWorkItemHierarchyMutation from '../../graphql/update_work_item_hierarchy.mutation.graphql';
import createWorkItemMutation from '../../graphql/create_work_item.mutation.graphql';
import {
  FORM_TYPES,
  WORK_ITEM_TYPE_NAME_EPIC,
  MAX_WORK_ITEMS,
  WIDGET_TYPE_MILESTONE,
  WIDGET_TYPE_ITERATION,
  WORK_ITEM_TYPE_NAME_TASK,
  NAME_TO_TEXT_LOWERCASE_MAP,
} from '../../constants';
import WorkItemProjectsListbox from './work_item_projects_listbox.vue';
import WorkItemGroupsListbox from './work_item_groups_listbox.vue';

export default {
  components: {
    GlForm,
    GlButton,
    GlFormGroup,
    GlFormInput,
    GlFormCheckbox,
    GlTooltip,
    WorkItemTokenInput,
    WorkItemProjectsListbox,
    WorkItemGroupsListbox,
  },
  mixins: [glFeatureFlagsMixin()],
  inject: ['hasIterationsFeature'],
  props: {
    fullPath: {
      type: String,
      required: true,
    },
    isGroup: {
      type: Boolean,
      required: false,
      default: false,
    },
    issuableGid: {
      type: String,
      required: false,
      default: null,
    },
    childrenIds: {
      type: Array,
      required: false,
      default: () => [],
    },
    parentConfidential: {
      type: Boolean,
      required: false,
      default: false,
    },
    parentIteration: {
      type: Object,
      required: false,
      default: () => ({}),
    },
    parentMilestone: {
      type: Object,
      required: false,
      default: () => ({}),
    },
    formType: {
      type: String,
      required: true,
    },
    parentWorkItemType: {
      type: String,
      required: false,
      default: '',
    },
    childrenType: {
      type: String,
      required: false,
      default: WORK_ITEM_TYPE_NAME_TASK,
    },
    fullName: {
      type: String,
      required: false,
      default: '',
    },
  },
  apollo: {
    workItemTypes: {
      query() {
        return namespaceWorkItemTypesQuery;
      },
      variables() {
        return {
          fullPath: this.fullPath,
        };
      },
      update(data) {
        return data.workspace?.workItemTypes?.nodes;
      },
    },
  },
  data() {
    return {
      workItemTypes: [],
      workItemsToAdd: [],
      error: null,
      isInputValid: true,
      search: '',
      selectedProjectFullPath: this.isGroup ? null : this.fullPath,
      selectedGroupFullPath: null,
      childToCreateTitle: null,
      confidential: this.parentConfidential,
      submitInProgress: false,
    };
  },
  computed: {
    workItemChildIsEpic() {
      return this.childrenType === WORK_ITEM_TYPE_NAME_EPIC;
    },
    workItemInput() {
      let workItemInput = {
        title: this.search?.title || this.search,
        workItemTypeId: this.childWorkItemTypeId,
        hierarchyWidget: {
          parentId: this.issuableGid,
        },
        confidential: this.parentConfidential || this.confidential,
      };

      if (this.selectedProjectFullPath && !this.workItemChildIsEpic) {
        workItemInput = {
          ...workItemInput,
          namespacePath: this.selectedProjectFullPath,
        };
      } else if (this.selectedGroupFullPath && this.workItemChildIsEpic) {
        workItemInput = {
          ...workItemInput,
          namespacePath: this.selectedGroupFullPath,
        };
      } else {
        workItemInput = {
          ...workItemInput,
          projectPath: this.fullPath,
        };
      }

      if (this.parentMilestoneId && this.isWidgetSupported(WIDGET_TYPE_MILESTONE)) {
        workItemInput = {
          ...workItemInput,
          milestoneWidget: {
            milestoneId: this.parentMilestoneId,
          },
        };
      }

      if (this.associateIteration && this.isWidgetSupported(WIDGET_TYPE_ITERATION)) {
        workItemInput = {
          ...workItemInput,
          iterationWidget: {
            iterationId: this.parentIterationId,
          },
        };
      }

      return workItemInput;
    },
    isCreateForm() {
      return this.formType === FORM_TYPES.create;
    },
    addOrCreateButtonLabel() {
      if (this.isCreateForm) {
        return sprintf(s__('WorkItem|Create %{workItemType}'), {
          workItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.childrenType],
        });
      }
      if (this.workItemsToAdd.length > 1) {
        return sprintf(s__('WorkItem|Add %{workItemType}s'), {
          workItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.childrenType],
        });
      }
      return sprintf(s__('WorkItem|Add %{workItemType}'), {
        workItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.childrenType],
      });
    },
    confidentialityCheckboxLabel() {
      return sprintf(
        s__(
          'WorkItem|Turn on confidentiality: Limit visibility to %{namespace} members with at least the Planner role.',
        ),
        { namespace: this.isGroup ? __('group') : __('project') },
      );
    },
    confidentialityCheckboxTooltip() {
      return sprintf(
        s__(
          'WorkItem|A non-confidential %{workItemType} cannot be assigned to a confidential parent %{parentWorkItemType}.',
        ),
        {
          workItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.childrenType],
          parentWorkItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.parentWorkItemType],
        },
      );
    },
    showConfidentialityTooltip() {
      return this.isCreateForm && this.parentConfidential;
    },
    addOrCreateMethod() {
      return this.isCreateForm ? this.createChild : this.addChild;
    },
    childWorkItemTypeId() {
      return this.workItemTypes.find((type) => type.name === this.childrenType)?.id;
    },
    parentIterationId() {
      return this.parentIteration?.id;
    },
    associateIteration() {
      return this.parentIterationId && this.hasIterationsFeature;
    },
    parentMilestoneId() {
      return this.parentMilestone?.id;
    },
    canCreateGroupLevelWorkItems() {
      return this.glFeatures.createGroupLevelWorkItems;
    },
    hasSuppliedNewItemName() {
      return this.search.length > 0;
    },
    hasSelectedProject() {
      return Boolean(this.selectedProjectFullPath);
    },
    canSubmitForm() {
      if (this.isCreateForm) {
        if (this.isGroup) {
          if (this.workItemChildIsEpic) {
            // must supply name, project will be ignored in request
            return this.hasSuppliedNewItemName;
          }
          if (!this.canCreateGroupLevelWorkItems) {
            // must supply name and project
            return this.hasSuppliedNewItemName && this.hasSelectedProject;
          }
        }
        return this.hasSuppliedNewItemName;
      }
      return this.workItemsToAdd.length > 0 && this.areWorkItemsToAddValid;
    },
    invalidWorkItemsToAdd() {
      return this.parentConfidential
        ? this.workItemsToAdd.filter((workItem) => !workItem.confidential)
        : [];
    },
    areWorkItemsToAddValid() {
      return this.invalidWorkItemsToAdd.length === 0 && this.areWorkItemsToAddWithinLimit;
    },
    showWorkItemsToAddInvalidMessage() {
      return !this.isCreateForm && this.invalidWorkItemsToAdd.length > 0;
    },
    workItemsToAddInvalidMessage() {
      return sprintf(
        s__(
          'WorkItem|%{invalidWorkItemsList} cannot be added: Cannot assign a non-confidential %{childWorkItemType} to a confidential parent %{parentWorkItemType}. Make the selected %{childWorkItemType} confidential and try again.',
        ),
        {
          invalidWorkItemsList: this.invalidWorkItemsToAdd.map(({ title }) => title).join(', '),
          childWorkItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.childrenType],
          parentWorkItemType: NAME_TO_TEXT_LOWERCASE_MAP[this.parentWorkItemType],
        },
      );
    },
    areWorkItemsToAddWithinLimit() {
      return this.workItemsToAdd.length <= MAX_WORK_ITEMS;
    },
  },
  watch: {
    workItemsToAdd() {
      this.unsetError();
    },
    workItemChildIsEpic: {
      handler(isEpic) {
        this.selectedGroupFullPath = isEpic ? this.fullPath : null;
      },
      immediate: true,
    },
  },
  methods: {
    getConfidentialityTooltipTarget() {
      // We want tooltip to be anchored to `input` within checkbox component
      // but `$el.querySelector('input')` doesn't work. 🤷‍♂️
      return this.$refs.confidentialityCheckbox?.$el;
    },
    unsetError() {
      this.error = null;
      this.isInputValid = true;
    },
    markFormSubmitInProgress(value) {
      this.submitInProgress = value;
      this.$emit('update-in-progress', this.submitInProgress);
      if (!value) this.$refs.wiTitleInput?.$el?.focus();
    },
    addChild() {
      this.markFormSubmitInProgress(true);
      this.$apollo
        .mutate({
          mutation: updateWorkItemHierarchyMutation,
          fetchPolicy: fetchPolicies.NO_CACHE,
          variables: {
            input: {
              id: this.issuableGid,
              hierarchyWidget: {
                childrenIds: this.workItemsToAdd.map((wi) => wi.id),
              },
            },
          },
          update: (
            cache,
            {
              data: {
                workItemUpdate: { workItem },
              },
            },
          ) =>
            addHierarchyChildren({
              cache,
              id: this.issuableGid,
              workItem,
              childrenIds: this.workItemsToAdd.map((wi) => wi.id),
            }),
        })
        .then(({ data }) => {
          // Marking submitInProgress cannot be in finally block
          // as the form may get close before the event is emitted
          this.markFormSubmitInProgress(false);
          if (data.workItemUpdate?.errors?.length) {
            [this.error] = data.workItemUpdate.errors;
          } else {
            this.unsetError();
            this.workItemsToAdd = [];
          }
        })
        .catch(() => {
          this.error = this.$options.i18n.addChildErrorMessage;
          this.isInputValid = false;
          this.markFormSubmitInProgress(false);
        })
        .finally(() => {
          this.search = '';
        });
    },
    createChild() {
      if (!this.canSubmitForm) {
        return;
      }
      this.markFormSubmitInProgress(true);
      this.$apollo
        .mutate({
          mutation: createWorkItemMutation,
          variables: {
            input: this.workItemInput,
          },
          update: (cache, { data }) =>
            addHierarchyChild({
              cache,
              id: this.issuableGid,
              workItem: data.workItemCreate.workItem,
            }),
        })
        .then(({ data }) => {
          // Marking submitInProgress cannot be in finally block
          // as the form may get close before the event is emitted
          this.markFormSubmitInProgress(false);
          if (data.workItemCreate?.errors?.length) {
            [this.error] = data.workItemCreate.errors;
          } else {
            this.unsetError();
            this.$emit('addChild');
          }
        })
        .catch(() => {
          this.error = this.$options.i18n.createChildErrorMessage;
          this.isInputValid = false;
          this.markFormSubmitInProgress(false);
        })
        .finally(() => {
          this.search = '';
          this.childToCreateTitle = null;
        });
    },
    closeForm() {
      this.$emit('cancel');
    },
    isWidgetSupported(widgetType) {
      const childrenType = this.workItemTypes.find((type) => type.name === this.childrenType);
      const widgetDefinitions = childrenType?.widgetDefinitions?.flatMap((i) => i.type) || [];
      return widgetDefinitions.indexOf(widgetType) !== -1;
    },
  },
  i18n: {
    titleInputLabel: __('Title'),
    projectInputLabel: __('Project'),
    groupInputLabel: __('Group'),
    addChildErrorMessage: s__(
      'WorkItem|Something went wrong when trying to add a child. Please try again.',
    ),
    createChildErrorMessage: s__(
      'WorkItem|Something went wrong when trying to create a child. Please try again.',
    ),
    titleInputPlaceholder: s__('WorkItem|Add a title'),
    projectInputPlaceholder: s__('WorkItem|Select a project'),
    groupInputPlaceholder: s__('WorkItem|Select a group'),
    titleInputValidationMessage: __('Maximum of 255 characters'),
  },
};
</script>

<template>
  <gl-form data-testid="add-item-form" @submit.prevent="addOrCreateMethod">
    <template v-if="isCreateForm">
      <div class="gl-flex gl-gap-x-3">
        <gl-form-group
          class="gl-w-full"
          :label="$options.i18n.titleInputLabel"
          :description="$options.i18n.titleInputValidationMessage"
          :invalid-feedback="error"
          :state="isInputValid"
          data-testid="work-items-create-form-group"
        >
          <gl-form-input
            ref="wiTitleInput"
            v-model="search"
            :placeholder="$options.i18n.titleInputPlaceholder"
            :state="isInputValid"
            maxlength="255"
            class="gl-mb-3"
            autofocus
          />
        </gl-form-group>
        <gl-form-group
          v-if="!workItemChildIsEpic"
          class="gl-w-full"
          :label="$options.i18n.projectInputLabel"
          :description="$options.i18n.projectValidationMessage"
        >
          <work-item-projects-listbox
            v-model="selectedProjectFullPath"
            class="gl-w-full"
            :full-path="fullPath"
            :current-project-name="fullName"
            :is-group="isGroup"
          />
        </gl-form-group>
        <gl-form-group
          v-else
          class="gl-w-full"
          :label="$options.i18n.groupInputLabel"
          :description="$options.i18n.groupValidationMessage"
        >
          <work-item-groups-listbox
            v-model="selectedGroupFullPath"
            class="gl-w-full"
            :full-path="fullPath"
            :current-group-name="fullName"
            @error="$emit('error', $event)"
          />
        </gl-form-group>
      </div>
      <gl-form-checkbox
        ref="confidentialityCheckbox"
        v-model="confidential"
        name="isConfidential"
        class="gl-mb-5 md:!gl-mb-3"
        :disabled="parentConfidential"
        >{{ confidentialityCheckboxLabel }}</gl-form-checkbox
      >
      <gl-tooltip
        v-if="showConfidentialityTooltip"
        :target="getConfidentialityTooltipTarget"
        triggers="hover"
        >{{ confidentialityCheckboxTooltip }}</gl-tooltip
      >
    </template>
    <div v-else class="gl-mb-4">
      <work-item-token-input
        v-model="workItemsToAdd"
        :is-create-form="isCreateForm"
        :is-group="isGroup"
        :parent-work-item-id="issuableGid"
        :children-type="childrenType"
        :children-ids="childrenIds"
        :are-work-items-to-add-valid="areWorkItemsToAddValid"
        :full-path="fullPath"
      />
      <div
        v-if="showWorkItemsToAddInvalidMessage"
        class="gl-text-danger"
        data-testid="work-items-invalid"
      >
        {{ workItemsToAddInvalidMessage }}
      </div>
      <div v-if="error" class="gl-mt-3 gl-text-danger" data-testid="work-items-error">
        {{ error }}
      </div>
      <div
        v-if="!areWorkItemsToAddWithinLimit"
        class="gl-mb-2 gl-text-danger"
        data-testid="work-items-limit-error"
      >
        {{ s__('WorkItem|Only 10 items can be added at a time.') }}
      </div>
    </div>
    <div class="gl-flex gl-gap-3">
      <gl-button
        category="primary"
        variant="confirm"
        size="small"
        type="submit"
        :disabled="!canSubmitForm"
        :loading="submitInProgress"
        data-testid="add-child-button"
      >
        {{ addOrCreateButtonLabel }}
      </gl-button>
      <gl-button category="secondary" size="small" @click="closeForm">
        {{ s__('WorkItem|Cancel') }}
      </gl-button>
    </div>
  </gl-form>
</template>
