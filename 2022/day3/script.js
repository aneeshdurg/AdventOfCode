_fileCache = {}
async function getFile(url) {
    if (url in _fileCache)
        return _fileCache[url];

    const resp = await fetch(url);
    if (resp.status !== 200)
        throw("Could not find shader " + url);

    let fileContents = "";
    const reader = resp.body.getReader();
    let done = false;
    while (!done) {
        let fileBody = await reader.read();
        if (!fileBody.value) {
            done = true;
        } else {
            for (let v of fileBody.value)
                fileContents += String.fromCharCode(v);
        }
    }
    _fileCache[url] = fileContents;
    return fileContents;
}

function findCommonElement(rucksack) {
  const length = rucksack.length;
  const comparment_length = length / 2;
  const comparment1 = new Set(rucksack.substring(0, comparment_length));
  const comparment2 = new Set(rucksack.substring(comparment_length));

  for (let c of comparment1) {
    if (comparment2.has(c)) {
      return c;
    }
  }

  throw new Error("Could not find common element");
}

function getElementScore(el) {
  const uppercase_a = "A".charCodeAt(0);
  const lowercase_a = "a".charCodeAt(0);

  const code = el.charCodeAt(0);
  if (code > lowercase_a) {
    return code - lowercase_a + 1;
  }
  return code - uppercase_a + 27;
}

document.addEventListener('DOMContentLoaded', async () => {
  console.log("!");
  const filecontents = await getFile("input.txt");
  const rucksacks = filecontents.split("\n");
  let total_score = 0;
  for (let rucksack of rucksacks) {
    if (rucksack.length == 0) {
      continue;
    }
    const el = findCommonElement(rucksack);
    const score = getElementScore(el);
    console.log(rucksack, el, score);
    total_score += score;
  }
  console.log(total_score);

  let total_badge_score = 0;
  for (let groupid = 0; groupid < rucksacks.length - 1; groupid += 3) {
    const elf1_rucksack = new Set(rucksacks[groupid + 0]);
    const elf2_rucksack = new Set(rucksacks[groupid + 1]);
    const elf3_rucksack = new Set(rucksacks[groupid + 2]);

    let badge = null;
    for (let el of elf1_rucksack) {
      if (elf2_rucksack.has(el) && elf3_rucksack.has(el)) {
        badge = el;
        break;
      }
    }

    if (badge == null) {
      throw new Error("Could not find badge");
    }

    const score = getElementScore(badge);
    total_badge_score += score;
  }
  console.log(total_badge_score);
});
