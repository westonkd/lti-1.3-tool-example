const webpack = require("webpack");
const path = require("path");

module.exports = {
  entry: {
    bundle: "./src/index",
    login: "./src/login",
    launch: "./src/launch"
  },
  module: {
    rules: [
      { test: /\.js?$/, use: "babel-loader", exclude: /node_modules/ },
      {
        test: /\.s?css$/,
        use: ["style-loader", "css-loader", "sass-loader"]
      }
    ]
  },
  resolve: {
    extensions: [".js", ".scss"]
  },
  output: {
    path: path.join(__dirname, "/web/app/public"),
    filename: "[name].js"
  },
  devtool: "eval-cheap-source-map",
  devServer: {
    contentBase: "./web/app/views/",
    hot: true
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin()
  ]
};
