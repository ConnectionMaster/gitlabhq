<script>
import { GlButton } from '@gitlab/ui';
import { __ } from '~/locale';

export default {
  name: 'DagAnnotations',
  components: {
    GlButton,
  },
  props: {
    annotations: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      showList: true,
    };
  },
  computed: {
    linkText() {
      return this.showList ? __('Hide list') : __('Show list');
    },
    shouldShowLink() {
      return Object.keys(this.annotations).length > 1;
    },
    wrapperClasses() {
      return [
        'gl-flex',
        'gl-flex-col',
        'gl-fixed',
        'gl-right-1',
        'gl-top-2/3',
        'gl-w-max',
        'gl-px-5',
        'gl-py-4',
        'gl-rounded-base',
        'gl-bg-white',
      ].join(' ');
    },
  },
  methods: {
    toggleList() {
      this.showList = !this.showList;
    },
  },
};
</script>
<template>
  <div :class="wrapperClasses">
    <div v-if="showList">
      <div v-for="note in annotations" :key="note.uid" class="gl-flex gl-items-center">
        <div
          data-testid="dag-color-block"
          class="gl-h-5 gl-w-6"
          :style="{
            background: `linear-gradient(0.25turn, ${note.source.color} 40%, ${note.target.color} 60%)`,
          }"
        ></div>
        <div data-testid="dag-note-text" class="gl-items-center gl-px-2 gl-text-base">
          {{ note.source.name }} → {{ note.target.name }}
        </div>
      </div>
    </div>

    <gl-button v-if="shouldShowLink" variant="link" @click="toggleList">{{ linkText }}</gl-button>
  </div>
</template>
