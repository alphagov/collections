c1="bundle show govuk_publishing_components";
x=$(eval $c1);
eval "cd $x";
ls;
yarn;
rollup -c --bundleConfigAsCjs rollup.config.js;