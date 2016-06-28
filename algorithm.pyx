import sys

# A Survey on Pixel-Based Skin Color Detection Techniques
def classify_skin(int r, int g, int b):

    if rgb_classifier(r, g, b):
        return True

    if norm_rgb_classifier(r, g, b):
        return True


    # TODO: Add normalized HSI, HSV, and a few non-parametric skin models too

    if hsv_classifier(r, g, b):
        return True

    if ycbcr_classifier(r, g, b):
        return True

    return False


cdef bint rgb_classifier(int r, int g, int b):
    cdef bint result
    result = r > 95 and 40 < g < 100 and b > 20 \
             and max(r, g, b) - min(r, g, b) > 15 \
             and abs(r - g) > 15 and r > g and r > b
    return result


cdef bint norm_rgb_classifier(int r, int g, int b):
    cdef bint result
    cdef float _sum, dr, dg, db
    if r == 0:
        dr = 0.0001
    if g == 0:
        dg = 0.0001
    if b == 0:
        db = 0.0001
    _sum = dr + dg + db
    nr, ng, nb = dr / _sum, dg / _sum, db / _sum
    result = nr / ng > 1.185 \
             and float(r * b) / ((r + g + b) ** 2) > 0.107 \
             and float(r * g) / ((r + g + b) ** 2) > 0.112
    return result


cdef bint hsv_classifier(int r, int g, int b):
    cdef bint result
    cdef int _max, _min
    cdef float _sum
    cdef float h = 0
    _sum = r + g + b
    _max = max(r, g, b)
    _min = min(r, g, b)
    diff = _max - _min
    if _sum == 0:
        _sum = 0.0001

    if _max == r:
        if diff == 0:
            h = sys.maxsize
        else:
            h = (g - b) / diff
    elif _max == g:
        h = 2 + ((g - r) / diff)
    else:
        h = 4 + ((r - g) / diff)

    h *= 60
    if h < 0:
        h += 360

    s, v = 1.0 - (3.0 * (_min / _sum)), (1.0 / 3.0) * _max
    result = 0 < h < 35 and 0.23 < s < 0.68
    return result


cdef bint ycbcr_classifier(int r, int g, int b):
    # Copied from here.
    # http://stackoverflow.com/questions/19459831/rgb-to-ycbcr-conversion-problems
    cdef bint result
    cdef float y, cb, cr
    y = 0.299 * r + 0.587 * g + 0.114 * b
    cb = 128 - 0.168736 * r - 0.331364 * g + 0.5 * b
    cr = 128 + 0.5 * r - 0.418688 * g - 0.081312 * b
    # Based on this paper http://research.ijcaonline.org/volume94/number6/pxc3895695.pdf
    result = 97.5 <= cb <= 142.5 and 134 <= cr <= 176
    return result

