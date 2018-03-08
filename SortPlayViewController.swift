//
//  SortPlayViewController.swift
//  ArraySortWithSwift
//
//  Created by liangchao on 2018/2/28.
//  Copyright © 2018年 lch. All rights reserved.
//
public class SortPlayViewController : UIViewController {
    private let kBarCount:Float = Float(100);
    fileprivate var sortTypes : [(name:String,type:SortType)]? = SortTool.supportSortTypes();
    fileprivate var timeLabel : UILabel! ;
    var sortType:SortType?;
    
    let screenSize = UIScreen.main.bounds.size;
    let screenWidth = Float(UIScreen.main.bounds.size.width);
    let screenHeight = Float(UIScreen.main.bounds.size.height);
    let signal = DispatchSemaphore(value: 0);
    
    
    
    fileprivate lazy var  barArray :[UIView] = {
        var array : [UIView] = [];
        
        for _ in 1...Int(self.kBarCount){
            let bar = UIView();
            bar.backgroundColor = UIColor.blue;
            self.view.addSubview(bar);
            array.append(bar);
            
            
        }
        return array;
    }();
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set up head view
        self.view.backgroundColor = UIColor.white;
        
        let sortItem = UIBarButtonItem(title: "开始排序", style: UIBarButtonItemStyle.done, target: self, action:#selector(startSort));
        self.navigationItem.rightBarButtonItem = sortItem;
        
        let resetItem = UIBarButtonItem(title: "重置", style: UIBarButtonItemStyle.done, target: self, action: #selector(reset));
        self.navigationItem.leftBarButtonItem = resetItem;
        let titles = self.sortTypes?.enumerated().map({$0.element.name});
        let segmentView = UISegmentedControl(items: titles);
        segmentView.frame = CGRect.init(x: 10, y: 64+10, width: UIScreen.main.bounds.width-10, height: 25);
        self.view.addSubview(segmentView);
        segmentView.addTarget(self, action: #selector(selectSorType(seg:)), for: UIControlEvents.valueChanged);
        
        self.timeLabel = UILabel(frame: CGRect.init(x: screenSize.width*0.5 - 50, y: screenSize.height*0.8, width: 120, height: 40));
        self.view.addSubview(self.timeLabel);
        self.timeLabel.textColor = UIColor.black;
        self.reset();
        self.timeLabel.text = "耗时(秒):"
    }
    
   @objc func startSort() -> Void {
    if(self.sortType == nil){
        let alert = UIAlertController(title: "", message: "请选择排序类型", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
        return;
        
    }
    
    let values:[Float] = self.barArray.map { Float($0.frame.size.height)
    };
    
    //子线程排序，主线程更新UI
    DispatchQueue.global().async {
        let timeStart = NSDate().timeIntervalSince1970;
        
        let concurrentQueue = DispatchQueue(label: "moveBar", attributes: .concurrent)

        SortTool.sortWith(type: self.sortType!, forVlaues: values, indexChangeCallback: { (i, j) in
            concurrentQueue.async(group: nil, qos: DispatchQoS.default, flags: DispatchWorkItemFlags.barrier, execute: {
                Thread.sleep(forTimeInterval: 0.002);
                DispatchQueue.main.async {
                    self.exchangeBarAt(i,j);
                };
            });
            }, complete: { (values) in
                let timeEnd = NSDate().timeIntervalSince1970;
                let costTime = timeEnd - timeStart;
                DispatchQueue.main.async {
                    self.timeLabel.text = String(format: "耗时(秒):%2.3f", arguments: [costTime]);
                };
            })
        }
    }
    
    
   @objc func reset() -> Void {
        self.timeLabel.text = nil;
        let barMargin = Float(1);
        let barAreaTop = Float( 64 + 10 + 25 + 10 );
        let barAreaHeight = screenHeight*0.8 - barAreaTop;
        let startX = Float(10);
        let barWidth = (screenWidth - 20 - barMargin*Float(kBarCount+1))/kBarCount;
    
        for (idx,bar) in self.barArray.enumerated() {
            let barHeight = Float(20) + Float(arc4random_uniform(UInt32(barAreaHeight - Float(20))));
            bar.frame = CGRect.init(x:CGFloat(startX + Float(idx)*(barWidth + barMargin)), y: CGFloat(screenHeight*0.8 - barHeight), width: CGFloat(barWidth), height: CGFloat(barHeight));
        }
    }
    
    func exchangeBarAt(_ i:Int,_ j:Int) -> () {

            var frameI = self.barArray[i].frame;
            var frameJ = self.barArray[j].frame;
            
            frameI.origin.x = self.barArray[j].frame.origin.x;
            frameJ.origin.x = self.barArray[i].frame.origin.x;
            
            self.barArray[i].frame = frameI;
            self.barArray[j].frame = frameJ;
            self.barArray.swapAt(i, j);
            self.view.setNeedsLayout();

    }
    
    @objc func selectSorType(seg:UISegmentedControl) -> () {
        self.sortType = SortTool.supportSortTypes()[seg.selectedSegmentIndex].type;
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
