from PIL import Image
import os

# 원본 파일 경로(assets 폴더 등에 복사해 두세요)
script_dir = os.path.dirname(os.path.abspath(__file__))
input_path = os.path.join(script_dir, 'crayon_frame_1_y_green.jpg')

# 출력 파일 경로
output_path = os.path.join(script_dir, 'crayon_frame_1_y_green_transparent.png')

img = Image.open(input_path).convert("RGBA")
datas = img.getdata()

newData = []
for item in datas:
    # R,G,B 모두 240 이상(거의 흰색)이면 완전 투명으로 변경
    if item[0] > 240 and item[1] > 240 and item[2] > 240:
        newData.append((255, 255, 255, 0))
    else:
        newData.append(item)

img.putdata(newData)
img.save(output_path)
print(f'Transparent PNG saved at: {output_path}')