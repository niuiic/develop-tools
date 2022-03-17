module.exports = function (api) {
  api.cache(true);
  return {
    presets: ["babel-preset-expo"],
    plugins: [
      [
        "module-resolver",
        {
          alias: {
            components: "./components",
            pages: "./pages",
            asserts: "./assets",
            utils: "./utils",
            reduxs: "./reduxs",
            config: "./config",
            "@native-base/icons": "@native-base/icons/lib",
          },
        },
      ],
    ],
  };
};
