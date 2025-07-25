<script>
// eslint-disable-next-line no-restricted-imports
import { mapState } from 'vuex';
import { GlBadge } from '@gitlab/ui';
import { helpPagePath } from '~/helpers/help_page_helper';
import { timeIntervalInWords } from '~/lib/utils/datetime_utility';
import { mergeUrlParams } from '~/lib/utils/url_utility';
import { s__, __, sprintf } from '~/locale';
import timeagoMixin from '~/vue_shared/mixins/timeago';
import DetailRow from './sidebar_detail_row.vue';

export default {
  name: 'JobSidebarDetailsContainer',
  components: {
    DetailRow,
    GlBadge,
  },
  mixins: [timeagoMixin],
  inject: ['pipelineTestReportUrl'],
  computed: {
    ...mapState(['job', 'testSummary']),
    coverage() {
      return `${this.job.coverage}%`;
    },
    showCoverage() {
      const jobCoverage = this.job.coverage;

      return jobCoverage || jobCoverage === 0;
    },
    duration() {
      return timeIntervalInWords(this.job.duration);
    },
    durationTitle() {
      return this.job.finished_at ? __('Duration') : __('Elapsed time');
    },
    erasedAt() {
      return this.timeFormatted(this.job.erased_at);
    },
    finishedAt() {
      return this.timeFormatted(this.job.finished_at);
    },
    hasTags() {
      return this.job?.tags?.length;
    },
    hasTimeout() {
      return this.job?.metadata?.timeout_human_readable ?? false;
    },
    hasAnyDetail() {
      return Boolean(
        this.job.duration ||
          this.job.finished_at ||
          this.job.erased_at ||
          this.job.queued_duration ||
          this.job.runner ||
          this.job.source ||
          this.job.coverage,
      );
    },
    runnerId() {
      const { id, short_sha: token, description } = this.job.runner;

      return `#${id} (${token}) ${description}`;
    },
    queuedDuration() {
      return timeIntervalInWords(this.job.queued_duration);
    },
    shouldRenderBlock() {
      return Boolean(this.hasAnyDetail || this.hasTimeout || this.hasTags);
    },
    source() {
      return this.$options.i18n.sources[this.job.source] || this.job.source;
    },
    timeout() {
      return `${this.job?.metadata?.timeout_human_readable}${this.timeoutSource}`;
    },
    timeoutSource() {
      if (!this.job?.metadata?.timeout_source) {
        return '';
      }

      return sprintf(__(' (from %{timeoutSource})'), {
        timeoutSource: this.job.metadata.timeout_source,
      });
    },
    runnerAdminPath() {
      return this.job?.runner?.admin_path || '';
    },
    hasTestSummaryDetails() {
      return Object.keys(this.testSummary).length > 0 && this.job?.test_suite_name;
    },
    testSummaryDescription() {
      let message;

      if (this.testSummary?.total?.failed > 0) {
        message = sprintf(__('%{failures} of %{total} failed'), {
          failures: this.testSummary?.total?.failed,
          total: this.testSummary?.total.count,
        });
      } else {
        message = sprintf(__('%{total}'), {
          total: this.testSummary?.total.count,
        });
      }

      return message;
    },
    testReportUrlWithJobName() {
      const urlParams = {
        job_name: this.job.test_suite_name,
      };

      return mergeUrlParams(urlParams, this.pipelineTestReportUrl);
    },
  },
  i18n: {
    COVERAGE: __('Coverage'),
    FINISHED: __('Finished'),
    ERASED: __('Erased'),
    QUEUED: __('Queued'),
    RUNNER: __('Runner'),
    SOURCE: __('Source'),
    TAGS: __('Tags'),
    TEST_SUMMARY: __('Test summary'),
    TIMEOUT: __('Timeout'),
    // Human-readable values of possible source values found in
    // https://docs.gitlab.com/api/graphql/reference/#cijobsource
    sources: {
      api: s__('JobSource|API'),
      chat: s__('JobSource|Chat'),
      container_registry_push: s__('JobSource|Container Registry Push'),
      duo_workflow: s__('JobSource|Duo Agent Platform'),
      external: s__('JobSource|External'),
      external_pull_request_event: s__('JobSource|External Pull Request'),
      merge_request_event: s__('JobSource|Merge Request'),
      ondemand_dast_scan: s__('JobSource|On-Demand DAST Scan'),
      ondemand_dast_validation: s__('JobSource|On-Demand DAST Validation'),
      parent_pipeline: s__('JobSource|Parent Pipeline'),
      pipeline: s__('JobSource|Pipeline'),
      pipeline_execution_policy: s__('JobSource|Pipeline Execution Policy'),
      pipeline_execution_policy_schedule: s__('JobSource|Scheduled Pipeline Execution Policy'),
      push: s__('JobSource|Push'),
      scan_execution_policy: s__('JobSource|Scan Execution Policy'),
      schedule: s__('JobSource|Schedule'),
      security_orchestration_policy: s__('JobSource|Scheduled Scan Execution Policy'),
      trigger: s__('JobSource|Trigger'),
      web: s__('JobSource|Web'),
      webide: s__('JobSource|Web IDE'),
      unknown: s__('JobSource|Unknown'),
    },
  },
  TIMEOUT_HELP_URL: helpPagePath('/ci/pipelines/settings.md', {
    anchor: 'set-a-limit-for-how-long-jobs-can-run',
  }),
};
</script>

<template>
  <div v-if="shouldRenderBlock">
    <detail-row v-if="job.duration" :value="duration" :title="durationTitle" />
    <detail-row
      v-if="job.finished_at"
      :value="finishedAt"
      data-testid="job-finished"
      :title="$options.i18n.FINISHED"
    />
    <detail-row v-if="job.erased_at" :value="erasedAt" :title="$options.i18n.ERASED" />
    <detail-row v-if="job.queued_duration" :value="queuedDuration" :title="$options.i18n.QUEUED" />
    <detail-row
      v-if="hasTimeout"
      :help-url="$options.TIMEOUT_HELP_URL"
      :value="timeout"
      data-testid="job-timeout"
      :title="$options.i18n.TIMEOUT"
    />
    <detail-row
      v-if="job.runner"
      :value="runnerId"
      :title="$options.i18n.RUNNER"
      :path="runnerAdminPath"
    />
    <detail-row v-if="job.source" :value="source" :title="$options.i18n.SOURCE" />
    <detail-row v-if="showCoverage" :value="coverage" :title="$options.i18n.COVERAGE" />
    <detail-row
      v-if="hasTestSummaryDetails"
      :value="testSummaryDescription"
      :title="$options.i18n.TEST_SUMMARY"
      :path="testReportUrlWithJobName"
      data-testid="test-summary"
    />

    <p v-if="hasTags" class="build-detail-row" data-testid="job-tags">
      <span class="font-weight-bold">{{ $options.i18n.TAGS }}:</span>
      <gl-badge v-for="(tag, i) in job.tags" :key="i" variant="info">{{ tag }}</gl-badge>
    </p>
  </div>
</template>
