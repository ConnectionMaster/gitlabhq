<script>
import { GlIcon, GlTooltip, GlPopover } from '@gitlab/ui';
import { s__, __ } from '~/locale';
import workItemByIidQuery from '~/work_items/graphql/work_item_by_iid.query.graphql';
import { findWidget } from '~/issues/list/utils';
import { i18n, WIDGET_TYPE_WEIGHT, WORK_ITEM_TYPE_VALUE_EPIC } from '../../constants';

export default {
  components: {
    GlIcon,
    GlTooltip,
    GlPopover,
  },
  i18n: {
    progressLabel: s__('WorkItem|Progress'),
    weightCompletedLabel: s__('WorkItem|issue weight completed'),
  },
  props: {
    fullPath: {
      type: String,
      required: true,
    },
    workItemType: {
      type: String,
      required: true,
    },
    workItemId: {
      type: String,
      required: true,
    },
    workItemIid: {
      type: String,
      required: false,
      default: null,
    },
  },
  apollo: {
    // eslint-disable-next-line @gitlab/vue-no-undef-apollo-properties
    workItem: {
      query: workItemByIidQuery,
      variables() {
        return {
          fullPath: this.fullPath,
          iid: this.workItemIid,
        };
      },
      update(data) {
        return data.workspace?.workItem || {};
      },
      skip() {
        return !this.workItemIid;
      },
      error(e) {
        this.$emit('error', i18n.fetchError);
        this.error = e.message || i18n.fetchError;
      },
    },
  },
  computed: {
    workItemWeight() {
      return findWidget(WIDGET_TYPE_WEIGHT, this.workItem);
    },
    shouldRolledUpWeightBeVisible() {
      return this.showRolledUpWeight && this.rolledUpWeight !== null;
    },
    showRolledUpProgress() {
      return this.rolledUpWeight && this.rolledUpCompletedWeight !== null;
    },
    showRolledUpWeight() {
      return this.workItemWeight?.widgetDefinition?.rollUp;
    },
    rolledUpWeight() {
      return this.workItemWeight?.rolledUpWeight;
    },
    rolledUpCompletedWeight() {
      return this.workItemWeight?.rolledUpCompletedWeight;
    },
    completedWeightPercentage() {
      return Math.round((this.rolledUpCompletedWeight / this.rolledUpWeight) * 100);
    },
    weightTooltip() {
      return this.workItemType === WORK_ITEM_TYPE_VALUE_EPIC ? __('Issue weight') : __('Weight');
    },
  },
};
</script>

<template>
  <div class="gl-flex">
    <!-- Rolled up weight -->
    <span
      v-if="shouldRolledUpWeightBeVisible"
      ref="weightData"
      tabindex="0"
      data-testid="work-item-rollup-weight"
      class="gl-ml-3 gl-flex gl-cursor-help gl-items-center gl-gap-2 gl-font-normal gl-text-secondary"
    >
      <gl-icon name="weight" class="gl-text-secondary" />
      <span data-testid="work-item-weight-value" class="gl-text-sm">{{ rolledUpWeight }}</span>
      <gl-tooltip :target="() => $refs.weightData">
        <span class="gl-font-bold">
          {{ weightTooltip }}
        </span>
      </gl-tooltip>
    </span>
    <!--- END Rolled up weight -->

    <!-- Rolled up Progress -->
    <span
      v-if="showRolledUpProgress"
      ref="progressBadge"
      tabindex="0"
      data-testid="work-item-rollup-progress"
      class="gl-ml-3 gl-flex gl-items-center gl-gap-2 gl-font-normal gl-text-secondary"
    >
      <gl-icon name="progress" class="gl-text-secondary" />
      <span data-testid="work-item-progress-value" class="gl-text-sm"
        >{{ completedWeightPercentage }}%</span
      >

      <gl-popover triggers="hover focus" :target="() => $refs.progressBadge">
        <template #title>{{ $options.i18n.progressLabel }}</template>
        <span class="gl-font-bold">{{ rolledUpCompletedWeight }}/{{ rolledUpWeight }}</span>
        {{ $options.i18n.weightCompletedLabel }}
      </gl-popover>
    </span>
    <!-- END Rolled up Progress -->
  </div>
</template>
