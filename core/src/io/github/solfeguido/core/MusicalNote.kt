package io.github.solfeguido.core

import com.badlogic.gdx.utils.Pool
import ktx.log.info

enum class NoteNameEnum(val value: String) {
    C("C"),
    D("D"),
    E("E"),
    F("F"),
    G("G"),
    H("H"),
    A("A"),
    B("B")
}

enum class NoteAccidentalEnum(val value: String) {
    Natural(""),
    Flat("b"),
    Sharp("#")
}

data class MusicalNote(
        var name: NoteNameEnum = NoteNameEnum.C,
        var level: Byte = 2,
        var accidental: NoteAccidentalEnum = NoteAccidentalEnum.Natural
) : Pool.Poolable {

    override fun toString(): String {
        return "${name.value}${accidental.value}$level"
    }

    override fun reset() {
        name = NoteNameEnum.C
        level = 2
        accidental = NoteAccidentalEnum.Natural
    }

    fun fromString(str: String) : MusicalNote {
        if(str.length < 2) return this// Can't do much
        name = NoteNameEnum.valueOf(str[0].toString())
        val levelOrAcc = str[1]
        if(levelOrAcc == '#') {
            accidental = NoteAccidentalEnum.Sharp
            level = str[2].toString().toByte()
        } else {
            accidental = NoteAccidentalEnum.Natural
            level = levelOrAcc.toString().toByte()
        }
        return this
    }
}