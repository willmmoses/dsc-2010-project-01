import imessage
import pandas as pd


def main():
    output = imessage.loader('chat.db')
    output.to_csv('messages.csv')
    print(output)


if __name__ == '__main__':
    main()
