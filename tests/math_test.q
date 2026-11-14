/ Example kx.test file. End assertion lines with ; so their results aren't echoed.
t:use`kx.test

t.feature`math;
t.assertMatch[{1+1};2;([name:"one plus one"])];
t.assertType[{1i+1i};"i";([name:"int plus int stays int"])];
t.assertError[{1+`f};"type";([name:"adding a symbol signals type"])];
