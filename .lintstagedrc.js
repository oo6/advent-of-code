module.exports = {
  "**/*.go?(x)": (items) => items.map((item) => `go fmt ${item}`),
  "**/*.exs?(x)": "mix format",
  "**/*.ts?(x)": "deno fmt",
  "**/*.swift?(x)": "swift-format -i",
};
