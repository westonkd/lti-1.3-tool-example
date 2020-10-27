const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: [
    './src/index'
  ],
  module: {
    rules: [
      { test: /\.js?$/, use: 'babel-loader', exclude: /node_modules/ },
      {
        test: /\.s?css$/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader'
        ]
      },
    ]
  },
  resolve: {
    extensions: ['.js', '.scss']
  },
  output: {
    path: path.join(__dirname, '/web/app/public'),
    filename: 'bundle.js'
  },
  devtool: 'eval-cheap-source-map',
  devServer: {
    contentBase: './web/app/views/',
    hot: true
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin()
  ]
}