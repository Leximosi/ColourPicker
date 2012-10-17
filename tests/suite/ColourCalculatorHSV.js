QUnit.module("ColourCalculatorHSV");
QUnit.test("ColourCalculatorHSV setup", function()
{
	expect(6);

	var hsv = new ColourCalculatorHSV(180, 100, 100);

	equal(hsv.getHSV(true)[0], 3);
	equal(hsv.getHSV(true)[1], 1);
	equal(hsv.getHSV(true)[2], 1);

	equal(hsv.getHSV()[0], 180);
	equal(hsv.getHSV()[1], 100);
	equal(hsv.getHSV()[2], 100);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [S = 0]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(180, 0, 87);

	equal(hsv.getRGB()[0], 222);
	equal(hsv.getRGB()[1], 222);
	equal(hsv.getRGB()[2], 222);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 360]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(360, 100, 100);

	equal(hsv.getRGB()[0], 255);
	equal(hsv.getRGB()[1], 0);
	equal(hsv.getRGB()[2], 0);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 300]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(300, 100, 100);

	equal(hsv.getRGB()[0], 255);
	equal(hsv.getRGB()[1], 0);
	equal(hsv.getRGB()[2], 255);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 240]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(240, 100, 100);

	equal(hsv.getRGB()[0], 0);
	equal(hsv.getRGB()[1], 0);
	equal(hsv.getRGB()[2], 255);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 180]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(180, 100, 100);

	equal(hsv.getRGB()[0], 0);
	equal(hsv.getRGB()[1], 255);
	equal(hsv.getRGB()[2], 255);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 120]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(120, 100, 100);

	equal(hsv.getRGB()[0], 0);
	equal(hsv.getRGB()[1], 255);
	equal(hsv.getRGB()[2], 0);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 60]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(60, 100, 100);

	equal(hsv.getRGB()[0], 255);
	equal(hsv.getRGB()[1], 255);
	equal(hsv.getRGB()[2], 0);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 0]", function()
{
	expect(3);

	var hsv = new ColourCalculatorHSV(0, 100, 100);

	equal(hsv.getRGB()[0], 255);
	equal(hsv.getRGB()[1], 0);
	equal(hsv.getRGB()[2], 0);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = -80]", function()
{
	expect(3);

	// -60 + 360
	var hsv = new ColourCalculatorHSV(-80, 100, 100);

	equal(hsv.getRGB()[0], 170);
	equal(hsv.getRGB()[1], 0);
	equal(hsv.getRGB()[2], 255);
});

QUnit.test("ColourCalculatorHSV HSV to RGB [H = 400]", function()
{
	expect(3);

	// 400 - 360
	var hsv = new ColourCalculatorHSV(400, 100, 100);

	equal(hsv.getRGB()[0], 255);
	equal(hsv.getRGB()[1], 170);
	equal(hsv.getRGB()[2], 0);
});
