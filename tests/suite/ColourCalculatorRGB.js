QUnit.module("ColourCalculatorRGB");
QUnit.test("ColourCalculatorRGB setup", function()
{
	expect(6);

	var RGB = new ColourCalculatorRGB(255, 255, 0);

	equal(RGB.getRGB(true)[0], 1);
	equal(RGB.getRGB(true)[1], 1);
	equal(RGB.getRGB(true)[2], 0);

	equal(RGB.getRGB()[0], 255);
	equal(RGB.getRGB()[1], 255);
	equal(RGB.getRGB()[2], 0);
});

QUnit.test("ColourCalculatorRGB RGB to RGB [0, 0, 0]", function()
{
	expect(3);

	var RGB = new ColourCalculatorRGB(0, 0, 0);

	equal(RGB.getHSV()[0], -1);
	equal(RGB.getHSV()[1], 0);
	equal(RGB.getHSV()[2], 0);
});

QUnit.test("ColourCalculatorRGB RGB to RGB [r max]", function()
{
	expect(3);

	var RGB = new ColourCalculatorRGB(255, 100, 100);

	equal(RGB.getHSV()[0], 0);
	equal(RGB.getHSV()[1], 61);
	equal(RGB.getHSV()[2], 100);
});

QUnit.test("ColourCalculatorRGB RGB to RGB [g max]", function()
{
	expect(3);

	var RGB = new ColourCalculatorRGB(100, 255, 100);

	equal(RGB.getHSV()[0], 120);
	equal(RGB.getHSV()[1], 61);
	equal(RGB.getHSV()[2], 100);
});

QUnit.test("ColourCalculatorRGB RGB to RGB [b max]", function()
{
	expect(3);

	var RGB = new ColourCalculatorRGB(100, 100, 255);

	equal(RGB.getHSV()[0], 240);
	equal(RGB.getHSV()[1], 61);
	equal(RGB.getHSV()[2], 100);
});

QUnit.test("ColourCalculatorRGB RGB to HEX [255, 0, 0]", function()
{
	expect(1);

	var RGB = new ColourCalculatorRGB(255, 0, 180);

	equal(RGB.getHEX(), '#ff00b4');
});
