#import "Basic";
#import "Machine_X64";

main :: () {
    cpu_info := get_cpu_info();         // (1)
    print("cpu_info: %\n", cpu_info);
    // => cpu_info: {INTEL, [3219913727, 4294636431, 0, 739248128, 289, 0, 10250153, 0, 3154117632, 0, 15]}
    if check_feature(cpu_info.feature_leaves, x86_Feature_Flag.AVX2) {  // (2)
        print("Yes, we have AVX2!"); // => Yes, we have AVX2!
        #asm AVX2 {
            pxor v1:, v1, v1;
        }
    } else {
         print("AVX2 is not available on this processor, we have to run our fallback path...");
    }   
}