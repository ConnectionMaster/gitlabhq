<script>
import { GlIcon, GlLink, GlTooltipDirective } from '@gitlab/ui';
import FileIcon from '~/vue_shared/components/file_icon.vue';

export default {
  name: 'PipelineEditorFileItem',
  components: {
    FileIcon,
    GlIcon,
    GlLink,
  },
  directives: {
    GlTooltip: GlTooltipDirective,
  },
  props: {
    file: {
      type: Object,
      required: true,
    },
  },
  computed: {
    fileName() {
      return this.file.location;
    },
    filePath() {
      return this.file.blob || this.file.raw;
    },
  },
};
</script>
<template>
  <gl-link
    v-gl-tooltip
    :href="filePath"
    :title="fileName"
    target="_blank"
    class="file-tree-includes-link gl-flex gl-justify-between gl-rounded-base gl-px-3 gl-py-2 gl-text-primary hover:gl-bg-gray-50 hover:gl-text-gray-900 hover:gl-no-underline"
  >
    <span class="file-row-name gl-str-truncated" :title="fileName">
      <file-icon class="file-row-icon" :file-name="fileName" />
      <span>{{ fileName }}</span>
    </span>
    <gl-icon class="gl-relative gl-hidden gl-text-gray-500" name="external-link" />
  </gl-link>
</template>
