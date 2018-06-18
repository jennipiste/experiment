// Each participant group has different order of conditions
// Latin square: (https://explorable.com/counterbalanced-measures-design)

const conditions = {
  1: ["A", "B", "C", "D"],
  2: ["A", "B", "D", "C"],
  3: ["A", "C", "B", "D"],
  4: ["A", "C", "D", "B"],
  5: ["A", "D", "B", "C"],
  6: ["A", "D", "C", "B"],
  7: ["B", "A", "C", "D"],
  8: ["B", "A", "D", "C"],
  9: ["B", "C", "A", "D"],
  10: ["B", "C", "D", "A"],
  11: ["B", "D", "A", "C"],
  12: ["B", "D", "C", "A"],
  13: ["C", "A", "B", "D"],
  14: ["C", "A", "D", "B"],
  15: ["C", "B", "A", "D"],
  16: ["C", "B", "D", "A"],
  17: ["C", "D", "A", "B"],
  18: ["C", "D", "B", "A"],
  19: ["D", "A", "B", "C"],
  20: ["D", "A", "C", "B"],
  21: ["D", "B", "A", "C"],
  22: ["D", "B", "C", "A"],
  23: ["D", "C", "A", "B"],
  24: ["D", "C", "B", "A"],
};

export default conditions;
