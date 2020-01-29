local Color = require('lib.Color')

_G['unpack'] = table.unpack

describe("Color testing", function()

    it("Shoud construct correctly", function()
        local color = Color()
        assert.are.equal(color.a, 1)
        assert.truthy(color)
        color = Color(0, 1, 0, 1)
        assert.are.equal(0, color.r)
    end)

    it("must be alterable", function()
        local white = Color()
        assert.truthy(white)
        white.a = 0
        assert.are.equal(0, white.a)
        white.r = 0.5
        assert.are.equal(0.5, white.r)
        assert.are.equal(0.5, white[1])
    end)

    it("Must be iterable", function()
        local black = Color(0, 0, 0, 0)
        for i,v in pairs(black) do
            assert.are.equal(0, v)
        end
    end)

    it("Should be unpackable", function()
        local gray = Color(0.5, 0.5, 0.5, 0.5)
        local r,g,b,a = table.unpack(gray)
        assert.are.same({0.5, 0.5, 0.5, 0.5}, {r,g,b,a})
    end)

    it("Should be clonable", function()
        local first = Color(0.1, 0.1, 0.1)
        local second = first:clone()
        assert.are.same(first, second)
        second.a = 0.5
        assert.are_not.same(first, second)
    end)

    it("Can be accessed with several parameters", function()
        local color = Color(1,0.2,0.3,0.5)
        local r,g,b,a = unpack(color.rgba)
        assert.are.same({1, 0.2, 0.3, 0.5}, {r,g,b, a})

        local a1,a2,a3 = unpack(color.aaa)
        assert.are.same({0.5, 0.5, 0.5}, {a1, a2, a3})

        a,b,g,r = unpack(color.abgr)
        assert.are.same({0.5, 0.3, 0.2, 1}, {a,b,g,r})
    end)

    it("Can be accessed directly", function()
        local color = Color(1,0.2,0.3,0.5)

        assert.are.equal(1, color[1])
        assert.are.equal(0.2, color[2])
        assert.are.equal(0.3, color[3])
        assert.are.equal(0.5, color[4])
    end)

    it("Can be set directly", function()
        local color = Color()
        color[1] = 1
        color[2] = 0.5
        color[3] = 1
        color[4] = 0

        assert.are.equal(1, color[1])
        assert.are.equal(0.5, color[2])
        assert.are.equal(1, color[3])
        assert.are.equal(0, color[4])
    end)
  end)