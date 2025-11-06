const { greet, add } = require('./index');

describe('Basic functions', () => {
  test('greet function returns correct greeting', () => {
    expect(greet('World')).toBe('Hello, World!');
  });

  test('add function returns sum of two numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
});