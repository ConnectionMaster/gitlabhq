<script>
import ImageViewer from '../../content_viewer/viewers/image_viewer.vue';
import { diffModes, imageViewMode } from '../constants';
import OnionSkinViewer from './image_diff/onion_skin_viewer.vue';
import SwipeViewer from './image_diff/swipe_viewer.vue';
import TwoUpViewer from './image_diff/two_up_viewer.vue';

export default {
  components: {
    ImageViewer,
  },
  props: {
    diffMode: {
      type: String,
      required: true,
    },
    newPath: {
      type: String,
      required: true,
    },
    oldPath: {
      type: String,
      required: true,
    },
    newSize: {
      type: Number,
      required: false,
      default: 0,
    },
    oldSize: {
      type: Number,
      required: false,
      default: 0,
    },
    encodePath: {
      type: Boolean,
      required: false,
      default: true,
    },
  },
  data() {
    return {
      mode: imageViewMode.twoup,
    };
  },
  computed: {
    imageViewComponent() {
      switch (this.mode) {
        case imageViewMode.twoup:
          return TwoUpViewer;
        case imageViewMode.swipe:
          return SwipeViewer;
        case imageViewMode.onion:
          return OnionSkinViewer;
        default:
          return undefined;
      }
    },
    isNew() {
      return this.diffMode === diffModes.new;
    },
    isRenamed() {
      return this.diffMode === diffModes.renamed;
    },
    imagePath() {
      return this.isNew || this.isRenamed ? this.newPath : this.oldPath;
    },
  },
  methods: {
    changeMode(newMode) {
      this.mode = newMode;
    },
  },
  diffModes,
  imageViewMode,
};
</script>

<template>
  <div class="diff-file-container">
    <div v-if="diffMode === $options.diffModes.replaced" class="diff-viewer">
      <div class="image js-replaced-image">
        <component :is="imageViewComponent" v-bind="$props">
          <template #image-overlay="{ renderedWidth, renderedHeight }">
            <slot
              :rendered-width="renderedWidth"
              :rendered-height="renderedHeight"
              name="image-overlay"
            ></slot>
          </template>
        </component>
      </div>
      <div class="view-modes">
        <ul class="view-modes-menu">
          <li
            :class="{
              active: mode === $options.imageViewMode.twoup,
            }"
            @click="changeMode($options.imageViewMode.twoup)"
          >
            {{ s__('ImageDiffViewer|2-up') }}
          </li>
          <li
            :class="{
              active: mode === $options.imageViewMode.swipe,
            }"
            @click="changeMode($options.imageViewMode.swipe)"
          >
            {{ s__('ImageDiffViewer|Swipe') }}
          </li>
          <li
            :class="{
              active: mode === $options.imageViewMode.onion,
            }"
            @click="changeMode($options.imageViewMode.onion)"
          >
            {{ s__('ImageDiffViewer|Onion skin') }}
          </li>
        </ul>
      </div>
    </div>
    <div v-else class="diff-viewer">
      <div class="image">
        <image-viewer
          :path="imagePath"
          :file-size="isNew ? newSize : oldSize"
          :inner-css-classes="[
            'frame',
            {
              added: isNew,
              deleted: diffMode === $options.diffModes.deleted,
            },
          ]"
          :encode-path="encodePath"
        >
          <template v-if="isNew || isRenamed" #image-overlay="{ renderedWidth, renderedHeight }">
            <slot
              :rendered-width="renderedWidth"
              :rendered-height="renderedHeight"
              name="image-overlay"
            ></slot>
          </template>
        </image-viewer>
      </div>
    </div>
  </div>
</template>
