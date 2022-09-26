package com.dmswide.bean;

public class Student {
    private Integer id;
    private String sno;
    private String name;
    private char gender = '男';
    private String password;
    private String email;
    private String telephone;
    private String address;
    private String introduction;
    private String portraitPath;
    private String clazzName;

    public Student(String name, String clazzName) {
        this.name = name;
        this.clazzName = clazzName;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSno() {
        return sno;
    }

    public void setSno(String sno) {
        this.sno = sno;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public char getGender() {
        return gender;
    }

    public void setGender(char gender) {
        this.gender = gender;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getPortraitPath() {
        return portraitPath;
    }

    public void setPortraitPath(String portraitPath) {
        this.portraitPath = portraitPath;
    }

    public String getClazzName() {
        return clazzName;
    }

    public void setClazzName(String clazzName) {
        this.clazzName = clazzName;
    }

    @Override
    public String toString() {
        return "Student{" +
            "id=" + id +
            ", sno='" + sno + '\'' +
            ", name='" + name + '\'' +
            ", gender=" + gender +
            ", password='" + password + '\'' +
            ", email='" + email + '\'' +
            ", telephone='" + telephone + '\'' +
            ", address='" + address + '\'' +
            ", introduction='" + introduction + '\'' +
            ", portraitPath='" + portraitPath + '\'' +
            ", clazzName='" + clazzName + '\'' +
            '}';
    }
}
