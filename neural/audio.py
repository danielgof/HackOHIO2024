import os

os.environ["KERAS_BACKEND"] = "jax"

import keras as keras
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.io.wavfile
from keras import layers
import tensorflow as tf
from scipy.signal import resample

keras.utils.set_random_seed(41)

BASE_DATA_DIR = "./neural/dataset/"
BATCH_SIZE = 16
NUM_CLASSES = 10
EPOCHS = 200
SAMPLE_RATE = 16000

pd_data = pd.read_csv(os.path.join(BASE_DATA_DIR, "drinks.csv"))

def read_wav_file(path, target_sr=SAMPLE_RATE):
    sr, wav = scipy.io.wavfile.read(os.path.join(BASE_DATA_DIR, path))
    wav = wav.astype(np.float32) / 32768.0  # normalize to [-1, 1]
    num_samples = int(len(wav) * target_sr / sr)  # resample to 16 kHz
    wav = resample(wav, num_samples)

    fixed_length = 999999
    if len(wav) < fixed_length:
        # Pad the waveform to the fixed length
        pad_width = fixed_length - len(wav)
        wav = np.pad(wav, (0, pad_width), mode='constant')
    else:
        # Truncate if it's longer than the fixed length
        wav = wav[:fixed_length]

    return wav[:, None] 

#def plot_single_spectrogram(sample_wav_data):
    spectrogram = layers.STFTSpectrogram(
        mode="log",
        frame_length=SAMPLE_RATE * 20 // 1000,
        frame_step=SAMPLE_RATE * 5 // 1000,
        fft_length=1024,
        trainable=False,
    )(sample_wav_data[None, ...])[0, ...]

    # Plot the spectrogram
    plt.imshow(spectrogram.T, origin="lower")
    plt.title("Single Channel Spectrogram")
    plt.xlabel("Time")
    plt.ylabel("Frequency")
    plt.show()

#def plot_multi_bandwidth_spectrogram(sample_wav_data):
    # All spectrograms must use the same `fft_length`, `frame_step`, and
    # `padding="same"` in order to produce spectrograms with identical shapes,
    # hence aligning them together. `expand_dims` ensures that the shapes are
    # compatible with image models.

    spectrograms = np.concatenate(
        [
            layers.STFTSpectrogram(
                mode="log",
                frame_length=SAMPLE_RATE * x // 1000,
                frame_step=SAMPLE_RATE * 5 // 1000,
                fft_length=1024,
                padding="same",
                expand_dims=True,
            )(sample_wav_data[None, ...])[0, ...]
            for x in [5, 10, 20]
        ],
        axis=-1,
    ).transpose([1, 0, 2])

    # normalize each color channel for better viewing
    mn = spectrograms.min(axis=(0, 1), keepdims=True)
    mx = spectrograms.max(axis=(0, 1), keepdims=True)
    spectrograms = (spectrograms - mn) / (mx - mn)

    plt.imshow(spectrograms, origin="lower")
    plt.title("Multi-bandwidth Spectrogram")
    plt.xlabel("Time")
    plt.ylabel("Frequency")
    plt.show()

sample_wav_data = read_wav_file(pd_data["filename"].tolist()[10])
#plt.plot(sample_wav_data[:, 0])
#plt.show()

#plot_single_spectrogram(sample_wav_data)

#plot_multi_bandwidth_spectrogram(sample_wav_data)

def read_dataset(df, folds):
    msk = df["fold"].isin(folds)
    filenames = df["filename"][msk]
    targets = df["target"][msk].values
    waves = np.array([read_wav_file(fil) for fil in filenames], dtype=np.float32)
    return waves, targets

train_x, train_y = read_dataset(pd_data, [1, 2, 3])
valid_x, valid_y = read_dataset(pd_data, [4])
test_x, test_y = read_dataset(pd_data, [5])

'''
model1d = keras.Sequential(
    [
        layers.InputLayer((None, 1)),
        layers.STFTSpectrogram(
            mode="log",
            frame_length=SAMPLE_RATE * 40 // 1000,
            frame_step=SAMPLE_RATE * 15 // 1000,
            trainable=False,
        ),
        layers.Conv1D(64, 64, activation="relu"),
        layers.Conv1D(128, 16, activation="relu"),
        layers.LayerNormalization(),
        layers.MaxPooling1D(4),
        layers.Conv1D(128, 8, activation="relu"),
        layers.Conv1D(256, 8, activation="relu"),
        layers.Conv1D(512, 4, activation="relu"),
        layers.LayerNormalization(),
        layers.Dropout(0.5),
        layers.GlobalMaxPooling1D(),
        layers.Dense(256, activation="relu"),
        layers.Dense(256, activation="relu"),
        layers.Dropout(0.5),
        layers.Dense(NUM_CLASSES, activation="softmax"),
    ],
    name="model_1d_non_trainble_stft",
)
'''
'''
model1d.compile(
    optimizer=keras.optimizers.Adam(1e-5),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
'''

#model1d.summary()

'''
history_model1d = model1d.fit(
    train_x,
    train_y,
    batch_size=BATCH_SIZE,
    validation_data=(valid_x, valid_y),
    epochs=EPOCHS,
    callbacks=[
        keras.callbacks.EarlyStopping(
            monitor="val_loss",
            patience=EPOCHS,
            restore_best_weights=True,
        )
    ],
)
'''

input = layers.Input((None, 1))
spectrograms = [
    layers.STFTSpectrogram(
        mode="log",
        frame_length=SAMPLE_RATE * frame_size // 1000,
        frame_step=SAMPLE_RATE * 15 // 1000,
        fft_length=2048,
        padding="same",
        expand_dims=True,
        # trainable=True,  # trainable by default
    )(input)
    for frame_size in [30, 40, 50]  # frame size in milliseconds
]

multi_spectrograms = layers.Concatenate(axis=-1)(spectrograms)

img_model = keras.applications.MobileNet(include_top=False, pooling="max")
output = img_model(multi_spectrograms)

output = layers.Dropout(0.5)(output)
output = layers.Dense(256, activation="relu")(output)
output = layers.Dense(256, activation="relu")(output)
output = layers.Dense(NUM_CLASSES, activation="softmax")(output)
model2d = keras.Model(input, output, name="model_2d_trainble_stft")

model2d.compile(
    optimizer=keras.optimizers.Adam(1e-4),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
model2d.summary()

history_model2d = model2d.fit(
    train_x,
    train_y,
    batch_size=BATCH_SIZE,
    validation_data=(valid_x, valid_y),
    epochs=EPOCHS,
    callbacks=[
        keras.callbacks.EarlyStopping(
            monitor="val_loss",
            patience=EPOCHS,
            restore_best_weights=True,
        )
    ],
)

epochs_range = range(EPOCHS)

plt.figure(figsize=(14, 5))
plt.subplot(1, 2, 1)
plt.plot(
    epochs_range,
    history_model1d.history["accuracy"],
    label="Training Accuracy,1D model with non-trainable STFT",
)
plt.plot(
    epochs_range,
    history_model1d.history["val_accuracy"],
    label="Validation Accuracy, 1D model with non-trainable STFT",
)
plt.plot(
    epochs_range,
    history_model2d.history["accuracy"],
    label="Training Accuracy, 2D model with trainable STFT",
)
plt.plot(
    epochs_range,
    history_model2d.history["val_accuracy"],
    label="Validation Accuracy, 2D model with trainable STFT",
)
plt.legend(loc="lower right")
plt.title("Training and Validation Accuracy")

plt.subplot(1, 2, 2)
plt.plot(
    epochs_range,
    history_model1d.history["loss"],
    label="Training Loss,1D model with non-trainable STFT",
)
plt.plot(
    epochs_range,
    history_model1d.history["val_loss"],
    label="Validation Loss, 1D model with non-trainable STFT",
)
plt.plot(
    epochs_range,
    history_model2d.history["loss"],
    label="Training Loss, 2D model with trainable STFT",
)
plt.plot(
    epochs_range,
    history_model2d.history["val_loss"],
    label="Validation Loss, 2D model with trainable STFT",
)
plt.legend(loc="upper right")
plt.title("Training and Validation Loss")
plt.show()

#_, test_acc = model1d.evaluate(test_x, test_y)
#print(f"1D model wit non-trainable STFT -> Test Accuracy: {test_acc * 100:.2f}%")

_, test_acc = model2d.evaluate(test_x, test_y)
print(f"2D model with trainable STFT -> Test Accuracy: {test_acc * 100:.2f}%")



