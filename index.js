const { LRUCache: LRU } = require('lru-cache');
const test = new LRU({
    max: 50,
    maxAge: 1000 * 60,
});
console.log('\x1B[32;1m--- REACHED END ---\x1B[0m');
