local Color = require('src.utils.Color')

_G['unpack'] = table.unpack

describe("Color testing", function()
  
    it("Shoud construct correctly", function()
        local color = Color()
        assert.are.equal(color.a, 1)
        assert.truthy(color)
        color = Color(0, 1, 0, 1)
        assert.are.equal(color.r, 0)
    end)

    it("must be alterable", function()
        local white = Color()
        assert.truthy(white)
        white.a = 0
        assert.are.equal(white.a, 0)
        white.r = 0.5
        assert.are.equal(white.r, 0.5)
        assert.are.equal(white[1], 0.5)
    end)

    it("Must be iterable", function()
        local black = Color(0, 0, 0, 0)
        for i,v in pairs(black) do
            assert.are.equal(v, 0)
        end
    end)

    it("Should be unpackable", function()
        local gray = Color(0.5, 0.5, 0.5, 0.5)
        local r,g,b,a = table.unpack(gray)
        assert.are.same({r,g,b,a}, {0.5, 0.5, 0.5, 0.5})
    end)

    it("Should be clonable", function()
        local first = Color(0.1, 0.1, 0.1)
        local second = first:clone()
        assert.are.same(first, second)
        second.a = 0.5
        assert.are_not.same(first, second)
    end)
  end)