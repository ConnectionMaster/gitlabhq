<script>
import { createAlert } from '~/alert';
import CrudComponent from '~/vue_shared/components/crud_component.vue';
import { TYPENAME_CI_RUNNER } from '~/graphql_shared/constants';
import { convertToGraphQLId } from '~/graphql_shared/utils';

import runnerJobsQuery from '../graphql/show/runner_jobs.query.graphql';
import {
  I18N_FETCH_ERROR,
  I18N_JOBS,
  I18N_NO_JOBS_FOUND,
  RUNNER_DETAILS_JOBS_PAGE_SIZE,
} from '../constants';
import { captureException } from '../sentry_utils';
import { getPaginationVariables } from '../utils';
import RunnerJobsTable from './runner_jobs_table.vue';
import RunnerPagination from './runner_pagination.vue';
import RunnerJobsEmptyState from './runner_jobs_empty_state.vue';

export default {
  name: 'RunnerJobs',
  components: {
    CrudComponent,
    RunnerJobsTable,
    RunnerPagination,
    RunnerJobsEmptyState,
  },
  props: {
    runnerId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      jobs: {
        count: '',
        items: [],
        pageInfo: {},
      },
      pagination: {},
    };
  },
  apollo: {
    jobs: {
      query: runnerJobsQuery,
      variables() {
        return this.variables;
      },
      update({ runner }) {
        return {
          count: runner?.jobCount || '',
          items: runner?.jobs?.nodes || [],
          pageInfo: runner?.jobs?.pageInfo || {},
        };
      },
      error(error) {
        createAlert({ message: I18N_FETCH_ERROR });
        captureException({ error, component: this.$options.name });
      },
    },
  },
  computed: {
    variables() {
      return {
        id: convertToGraphQLId(TYPENAME_CI_RUNNER, this.runnerId),
        ...getPaginationVariables(this.pagination, RUNNER_DETAILS_JOBS_PAGE_SIZE),
      };
    },
    loading() {
      return this.$apollo.queries.jobs.loading;
    },
  },
  methods: {
    onPaginationInput(value) {
      this.pagination = value;
    },
  },
  I18N_JOBS,
  I18N_NO_JOBS_FOUND,
};
</script>

<template>
  <crud-component
    :title="$options.I18N_JOBS"
    icon="pipeline"
    :count="jobs.count"
    :is-loading="loading"
    class="gl-mt-5"
  >
    <runner-jobs-table v-if="jobs.items.length" :jobs="jobs.items" />
    <runner-jobs-empty-state v-else />

    <template #pagination>
      <runner-pagination
        :disabled="loading"
        :page-info="jobs.pageInfo"
        @input="onPaginationInput"
      />
    </template>
  </crud-component>
</template>
