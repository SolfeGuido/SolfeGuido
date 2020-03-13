package io.github.solfeguido.core

import com.badlogic.gdx.assets.AssetManager
import com.badlogic.gdx.audio.Sound
import com.badlogic.gdx.utils.ObjectSet
import io.github.solfeguido.utils.NoteDataPool
import ktx.collections.toGdxSet
import ktx.inject.Context

class SoundHelper(private val context: Context) {

    val existingSounds : ObjectSet<MusicalNote>

    init {
        existingSounds = listOf(
                "A" to (1..5),
                "C" to (2..6),
                "D#" to (2..6),
                "F#" to (2..6)
        ).map {
            pair -> pair.second.map { context.inject<NoteDataPool>().fromString("${pair.first}$it") }
        }.flatten()
         .toGdxSet()
    }

    private fun toAssetName(note: MusicalNote) = "sounds/notes/$note.mp3"

    private fun noteExists(note: MusicalNote) = existingSounds.contains(note)

    fun playNote(note: MusicalNote) {
        val assetManager: AssetManager = context.inject()
        if(noteExists(note)) {
            assetManager.get<Sound>(toAssetName(note)).play()
        } else {
            // Find the closest note and play it
        }
    }
}