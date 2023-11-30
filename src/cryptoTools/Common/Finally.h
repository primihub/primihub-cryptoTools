#pragma once

#include <functional>

namespace primihub::osuCrypto
{

    class Finally
    {
        std::function<void()> mFinalizer;
        Finally() = delete;

    public:
        Finally(const Finally& other) = delete;
        Finally(std::function<void()> finalizer)
            : mFinalizer(finalizer)
        {
        }
        ~Finally()
        {
            if (mFinalizer)
                mFinalizer();
        }
    };
}
