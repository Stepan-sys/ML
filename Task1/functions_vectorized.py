import numpy as np

def prod_non_zero_diag(x):
    diag = np.diagonal(x)
    nonZero = diag[diag != 0]
    if (len(nonZero) == 0):
        return 0
    return np.prod(nonZero)


def are_multisets_equal(x, y):
    return np.equal(np.sort(x), np.sort(y))


def max_after_zero(x):
    mask = x[:-1] == 0
    candidates = x[1:][mask]
    return np.max(candidates) if candidates.size > 0 else None


def convert_image(img, coefs):
    return np.dot(img, coefs)



def run_length_encoding(x):
    changes = np.where(np.diff(x) != 0)[0] + 1
    values = np.concatenate(([x[0]], x[changes]))
    counts = np.diff(np.concatenate(([0], changes, [len(x)])))
    return values, counts


def pairwise_distance(x, y):
    return np.linalg.norm(x[:, np.newaxis, :] - y[np.newaxis, :, :], axis=2)