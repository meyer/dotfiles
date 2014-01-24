# defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# See `systemsetup -listtimezones` for other values
systemsetup -settimezone "America/Los_Angeles" > /dev/null

# Time formatting
# Credit: https://github.com/ymendel/dotfiles/blob/master/osx/locale.defaults

defaults write com.apple.systempreferences AppleIntlCustomFormat -dict-add "AppleIntlCustomLocale" "en_GB"
defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add "1" "yyyy/MM/dd"
# defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add "1" "d/M/yy "
# defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add "2" "d MMM yyyy"
# defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add "3" "d MMMM yyyy"
# defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add "4" "EEEE, d MMMM yyyy"

# 24-hour time is the only way to roll
# defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict-add "1" "H:mm "
# defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict-add "2" "H:mm:ss "
# defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict-add "3" "H:mm:ss  z"
# defaults write NSGlobalDomain AppleICUTimeFormatStrings -dict-add "4" "H:mm:ss  z"

# also set this for the system preference
# defaults write com.apple.systempreferences AppleIntlCustomFormat -dict-add "AppleIntlCustomICUDictionary" "{'AppleICUDateFormatStrings'={'1'='d/M/yy ';'2'='d MMM yyyy';'3'='d MMMM yyyy';'4'='EEEE, d MMMM yyyy';};'AppleICUTimeFormatStrings'={'1'='H:mm ';'2'='H:mm:ss ';'3'='H:mm:ss  z';'4'='H:mm:ss  z';};}"

# EEE = Three-letter day
defaults write com.apple.menuextra.clock DateFormat -string 'EEE HH:mm'