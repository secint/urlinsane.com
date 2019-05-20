module.exports = {
  devServer: {
    proxy: {
      '/api/typo': {
        changeOrigin: true,
        target: 'http://api.urlinsane.com',
        pathRewrite: {
          '^/api/typo': '',
        },
      },
    },
  },
  css: {
    loaderOptions: {
      sass: {
        // eslint-disable-next-line quotes
        data: `@import "@/scss/_variables.scss";`,
      },
    },
  },
};
