echo "i am even running this at all?"
c1="bundle show govuk_publishing_components";
x=$(eval $c1);
eval "cd $x";
echo "i am in the right place?"
ls;
yarn;
rollup -c --bundleConfigAsCjs rollup.config.js;