const fs = require("fs");

function content(year, day, color) {
  return `{
  "schemaVersion": 1,
  "label": "AoC ${year}",
  "message": "${day}/25",
  "color": "${color}"
}`;
}

fs.readdirSync(`${__dirname}/../`).forEach((year) => {
  if (2015 <= year && year <= new Date().getFullYear()) {
    const day = Math.max(
      ...fs.readdirSync(year).map((day) => ~~day.slice(0, 2))
    );
    fs.writeFileSync(
      `${__dirname}/${year}.json`,
      content(year, day, day == 25 ? "brightgreen" : "orange")
    );
  }
});
