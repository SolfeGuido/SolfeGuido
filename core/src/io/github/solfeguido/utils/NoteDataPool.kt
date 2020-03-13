package io.github.solfeguido.utils

import com.badlogic.gdx.utils.Pool
import io.github.solfeguido.core.NoteAccidentalEnum
import io.github.solfeguido.core.MusicalNote
import io.github.solfeguido.core.NoteNameEnum

class NoteDataPool : Pool<MusicalNote>() {
    override fun newObject(): MusicalNote {
        return MusicalNote()
    }

    fun get(name: NoteNameEnum, level: Byte, accidentalEnum: NoteAccidentalEnum = NoteAccidentalEnum.Natural) : MusicalNote {
        return obtain().also {
            it.name = name
            it.level = level
            it.accidental = accidentalEnum
        }
    }

    fun fromString(str: String) = obtain().fromString(str)
}