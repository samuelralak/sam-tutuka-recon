const { environment } = require('@rails/webpacker')
const webpack = require("webpack")

// https://github.com/rails/webpacker/issues/2784#issuecomment-737003955
function hotfixPostcssLoaderConfig (subloader) {
    const subloaderName = subloader.loader
    if (subloaderName === 'postcss-loader') {
        if (subloader.options.postcssOptions) {
            console.log(
                '\x1b[31m%s\x1b[0m',
                'Remove postcssOptions workaround in config/webpack/environment.js'
            )
        } else {
            subloader.options.postcssOptions = subloader.options.config;
            delete subloader.options.config;
        }
    }
}

environment.loaders.keys().forEach(loaderName => {
    const loader = environment.loaders.get(loaderName);
    loader.use.forEach(hotfixPostcssLoaderConfig);
});

environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
}))

module.exports = environment
