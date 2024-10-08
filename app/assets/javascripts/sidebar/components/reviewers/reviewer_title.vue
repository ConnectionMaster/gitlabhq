<script>
// NOTE! For the first iteration, we are simply copying the implementation of Assignees
// It will soon be overhauled in Issue https://gitlab.com/gitlab-org/gitlab/-/issues/233736
import { MountingPortal } from 'portal-vue';
import { GlLoadingIcon, GlButton, GlTooltipDirective } from '@gitlab/ui';
import glFeatureFlagsMixin from '~/vue_shared/mixins/gl_feature_flags_mixin';
import { n__, s__ } from '~/locale';
import ReviewerDrawer from '~/merge_requests/components/reviewers/reviewer_drawer.vue';

export default {
  name: 'ReviewerTitle',
  components: {
    MountingPortal,
    GlLoadingIcon,
    GlButton,
    ReviewerDrawer,
  },
  directives: {
    Tooltip: GlTooltipDirective,
  },
  mixins: [glFeatureFlagsMixin()],
  props: {
    loading: {
      type: Boolean,
      required: false,
      default: false,
    },
    numberOfReviewers: {
      type: Number,
      required: true,
    },
    editable: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      drawerOpen: false,
    };
  },
  computed: {
    reviewerTitle() {
      const reviewers = this.numberOfReviewers;
      return n__('Reviewer', `%d Reviewers`, reviewers);
    },
  },
  methods: {
    toggleDrawerOpen(drawerOpen = !this.drawerOpen) {
      if (!this.glFeatures.reviewerAssignDrawer) return;

      this.drawerOpen = drawerOpen;
    },
  },
  i18n: {
    addEditReviewers: s__('MergeRequest|Add or edit reviewers'),
    changeReviewer: s__('MergeRequest|Change reviewer'),
    quickAdd: s__('MergeRequest|Quick add reviewers'),
  },
};
</script>
<template>
  <div
    class="hide-collapsed gl-flex gl-items-center gl-gap-2 gl-font-bold gl-leading-20 gl-text-gray-900"
  >
    {{ reviewerTitle }}
    <gl-loading-icon v-if="loading" size="sm" inline class="align-bottom" />
    <template v-if="editable">
      <gl-button
        v-tooltip.hover
        :title="
          glFeatures.reviewerAssignDrawer
            ? $options.i18n.addEditReviewers
            : $options.i18n.changeReviewer
        "
        class="hide-collapsed gl-float-right gl-ml-auto"
        :class="{ 'js-sidebar-dropdown-toggle edit-link': !glFeatures.reviewerAssignDrawer }"
        data-track-action="click_edit_button"
        data-track-label="right_sidebar"
        data-track-property="reviewer"
        :data-testid="glFeatures.reviewerAssignDrawer ? 'drawer-toggle' : 'reviewers-edit-button'"
        category="tertiary"
        size="small"
        @click="toggleDrawerOpen(!drawerOpen)"
      >
        {{ __('Edit') }}
      </gl-button>
    </template>
    <mounting-portal v-if="glFeatures.reviewerAssignDrawer" mount-to="#js-reviewer-drawer-portal">
      <reviewer-drawer
        :open="drawerOpen"
        @request-review="(params) => $emit('request-review', params)"
        @remove-reviewer="(data) => $emit('remove-reviewer', data)"
        @close="toggleDrawerOpen(false)"
      />
    </mounting-portal>
  </div>
</template>
