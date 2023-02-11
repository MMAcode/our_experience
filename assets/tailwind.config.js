// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");

miroVariablesForBetterButtons = {
  shadow: {
    inset:
      "0 0 0 2px var(--colour-white), 0 0 0 5px var(--colour-green), inset 0 -4px 0 rgba(0, 0, 0, 0.24)",
  },
  keyframes: {
    wiggle: {
      "0%, 100%": { transform: "rotate(0deg)" },
      "25%, 75%": { transform: "rotate(-3deg)" },
      "50%": { transform: "rotate(3deg)" },
    },
  },
  animation: {
    wiggle: "wiggle 0.2s ease-in-out forwards",
  },
};

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex, './src/**/*.{html,js}', './node_modules/tw-elements/dist/js/**/*.js'",
  ],
  theme: {
    extend: {
      miroVariablesForBetterButtons,
      colors: {
        brand: "#FD4F00",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),
    require("tw-elements/dist/plugin"), //I added this, after installing npm, probably not needed as all through cdn now; https://tailwind-elements.com/quick-start/
  ],
};
