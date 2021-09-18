# https://mametter.hatenablog.com/entry/20091003/p1

require 'zlib'

width = 100
height = 20
depth = 8
color_type = 2

# グラデーションのベタデータ
line = (0...width).map { [(_1 * 255 / width), 0, 0] }
raw_data = [line] * height

# チャンクのバイト列生成関数
def chunk(type, data)
  [data.bytesize, type, data, Zlib.crc32(type + data)].pack('NA4A*N')
end

# ファイルシグニチャ
print "\x89PNG\r\n\x1a\n"

# ヘッダ
print chunk('IHDR', [width, height, depth, color_type, 0, 0, 0].pack('NNCCCCC'))

# 画像データ
img_data = raw_data.map { |line| ([0] + line.flatten).pack('C*') }.join
print chunk('IDAT', Zlib::Deflate.deflate(img_data))

# 終端
print chunk('IEND', '')
