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
    let day;

    if (year == 2021) {
      day = Math.max(
        ...fs
          .readdirSync(`${year}/lib/`)
          .filter((path) => fs.lstatSync(`${year}/lib/${path}`).isDirectory())
          .map((day) => ~~day.slice(4, 6))
      );
    } else {
      day = Math.max(...fs.readdirSync(year).map((day) => ~~day.slice(0, 2)));
    }
    fs.writeFileSync(
      `${__dirname}/${year}.json`,
      content(year, day, day == 25 ? "brightgreen" : "orange")
    );
  }
});
