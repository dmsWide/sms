package com.dmswide.util;

import com.dmswide.bean.Grade;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Random;

public class CreateVerificationCode {
    //宽 高 字体大小 验证码字符数组长度为:4 以及验证码图片
    private static int WIDTH = 90;
    private static int HEIGHT = 35;
    private static int FONT_SIZE = 20;
    private static char[] verificationCode;
    private static BufferedImage verificationCodeImage;

    public static BufferedImage generateVerificationCodeImage(){
        //生成底图
        verificationCodeImage = new BufferedImage(WIDTH,HEIGHT,BufferedImage.TYPE_INT_RGB);
        Graphics graphics = verificationCodeImage.getGraphics();

        verificationCode = generateVerificationCode();
        drawBackground(graphics);
        drawCode(graphics);
        graphics.dispose();
        return verificationCodeImage;
    }

    public static char[] getVerificationCode() {
        return verificationCode;
    }

    public static char[] generateVerificationCode(){
        String str = "0123456789" + "abcdefghigklmnopqrstuvwxyz" + "ABCDEFGHIGKLMNOPQRSTUVWXYZ";
        char[] chars = new char[4];
        for(int i = 0;i < 4;i++){
            Random random = new Random();
            chars[i] = (char)str.charAt(random.nextInt(10 + 26 * 2));
        }
        return chars;
    }

    private static void drawCode(Graphics graphics){
        graphics.setFont(new Font("Console",Font.BOLD,FONT_SIZE));
        for(int i = 0;i < verificationCode.length;i++){
            graphics.setColor(getRandomColor());
            graphics.drawString("" + verificationCode[i],i * FONT_SIZE + 10,25);
        }
    }

    private static void drawBackground(Graphics graphics){
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0,0,WIDTH,HEIGHT);

        //设置噪点
        for(int i = 0;i < 200;i++){
            int x = (int)(Math.random() * WIDTH);
            int y = (int)(Math.random() * HEIGHT);
            graphics.setColor(getRandomColor());
            graphics.drawOval(x,y,1,1);
        }
    }
    private static Color getRandomColor(){
        Random random = new Random();
        return new Color(random.nextInt(220),random.nextInt(220),random.nextInt(220));
    }
}
