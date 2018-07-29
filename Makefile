format:
	swiftlint autocorrect

clean-pods:
	rm -rf BlackJackBuddy/Pods/*

install:
	cd BlackJackBuddy/BlackJackBuddy; pod install
