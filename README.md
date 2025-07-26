# WebtoonManager

웹툰 관리를 위한 간단한 SwiftUI 앱 스켈레톤입니다.

## 빌드 방법
Xcode(iOS 17 이상)에서 새로운 iOS 앱 프로젝트를 만든 뒤 템플릿 소스 파일을 `WebtoonManager` 폴더의 내용으로 교체하고 `WebtoonManagerApp` 타깃을 빌드합니다.
프로젝트에 `WebtoonManager/Info.plist` 파일을 복사하거나, 자신의 Info.plist에 `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `NSAppTransportSecurity`(`NSAllowsArbitraryLoads` 포함)을 추가해야 합니다. 이 파일을 가져왔다면 타깃의 **Info.plist File** 설정을 교체하고 *Copy Bundle Resources* 단계에서 중복 항목을 제거하여 여러 Info.plist 파일 오류를 방지합니다.

## 주요 기능
- 홈, 검색, 웹툰 추가, 설정의 네 개 탭 제공
- 검색 결과에서 상세 페이지로 이동하면 읽기 진행률을 표시하는 막대 제공
- 썸네일 URL 등을 포함한 웹툰 정보 저장을 위한 기본 데이터 모델
- 설정에서 활성화하면 앱 실행 중 자동으로 API 업데이트 수행
- 홈 화면에 가로 약 390pt로 조정된 `AppLogo` 이미지를 표시하므로 `AppLogo`라는 이름의 정사각형 에셋만 추가하면 자동 조정
- 마지막에 선택한 탭과 저장된 웹툰을 앱 재실행 후에도 기억
- 검색 탭에서 스와이프 액션으로 웹툰을 편집하거나 삭제 가능하며, 정렬 기준은 평점·제목·최근 업데이트 순
- 웹툰 등록/수정 시 여러 작가와 장르 입력, 회차 수 입력 및 로컬 이미지 선택 지원
- 설정 → 카테고리 관리에서 전역 작가·스튜디오·장르 목록 관리
- 라이트·다크·세피아·포스터·핑크 테마 중 선택 가능하며 즉시 적용
- 목록 편집 시 - 버튼을 통해 저장된 카테고리, 작가, 스튜디오 삭제
- 첫 실행 시 사진 라이브러리 권한과 자동 업데이트용 네트워크 접근 허용 여부를 요청
