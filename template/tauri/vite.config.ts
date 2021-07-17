import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import tauri from "./tauri-plugin";

export default defineConfig({
  plugins: [vue(), tauri()],
  server: {
    hmr: { overlay: false },
  },
  resolve: {
    alias: { vue: "vue/dist/vue.esm-bundler.js" },
  },
});
