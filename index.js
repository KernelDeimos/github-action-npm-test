const main = async () => {
    const lruUser = (await import('lru-user')).default;
    lruUser.run();
};
main();
